import 'dart:async';

import '../../core/services/game_effects.dart';
import '../../core/storage/progress_database.dart';
import 'settings_provider.dart';
import 'effects_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../engine/content/tutorial_boards.dart';
import '../../engine/content/challenge_catalog.dart';
import '../../engine/models/challenge_progress.dart';
import '../../engine/generator/puzzle_generator.dart';
import '../../engine/models/board.dart';
import '../../engine/models/connection_mask.dart';
import '../../engine/models/game_session.dart';
import '../../engine/models/tile.dart';
import '../../models/puzzle_enums.dart';
import '../models/puzzle_view.dart';

final puzzleBoardFactoryProvider = Provider<Board Function(int, int)>((ref) {
  return (size, seed) => seed < 0
      ? TutorialBoards.lesson(-seed - 1)
      : PuzzleGenerator.generate(size: size, seed: seed);
});

/// In-memory view of durable scores. Tutorial boards are never recorded.
class MemoryBests {
  final Map<(int, int, int), int> _moves = {};
  final Map<(int, int, int), int> _stars = {};
  MemoryBests([ProgressSnapshot snapshot = const ProgressSnapshot()]) {
    for (final score in snapshot.scores) {
      final key = (score.size, score.seed, score.version);
      _moves[key] = score.moves;
      _stars[key] = score.stars;
    }
  }
  int starsFor(Board board) =>
      _stars[(board.size, board.seed, board.generatorVersion)] ?? 0;
  bool record(Board board) {
    final stars = StarRating.calculate(
      movesTaken: board.movesTaken,
      par: board.par,
    ).count;
    final scoreKey = (board.size, board.seed, board.generatorVersion);
    if (stars > (_stars[scoreKey] ?? 0)) _stars[scoreKey] = stars;
    final key = (board.size, board.seed, board.generatorVersion);
    final previous = _moves[key];
    if (previous != null && previous <= board.movesTaken) return false;
    _moves[key] = board.movesTaken;
    return true;
  }

  int? movesFor(int size, int seed, int version) =>
      _moves[(size, seed, version)];
}

final memoryBestsProvider = Provider(
  (ref) => MemoryBests(ref.watch(progressSnapshotProvider)),
);
final puzzleProvider = StateNotifierProvider.autoDispose
    .family<PuzzleNotifier, PuzzleState, (int, int)>(
      (ref, key) => PuzzleNotifier(
        ref.watch(puzzleBoardFactoryProvider)(key.$1, key.$2),
        bests: key.$2 < 0 ? null : ref.read(memoryBestsProvider),
        persist: key.$2 < 0
            ? null
            : _persistence(ref.read(progressDatabaseProvider)),
        effect: (cue) => unawaited(ref.read(gameEffectsProvider)?.play(cue)),
      ),
    );

TileView _tileView(Tile tile) => TileView(
  row: tile.row,
  col: tile.col,
  mask: tile.effectiveMask,
  north: ConnectionMask.hasNorth(tile.effectiveMask),
  east: ConnectionMask.hasEast(tile.effectiveMask),
  south: ConnectionMask.hasSouth(tile.effectiveMask),
  west: ConnectionMask.hasWest(tile.effectiveMask),
);

class PuzzleNotifier extends StateNotifier<PuzzleState> {
  final GameSession _session;
  final MemoryBests? _bests;
  final String _paletteId;
  final int Function()? _onWin;
  final Future<void> Function(Board)? _persist;
  final void Function(GameCue)? _effect;
  int _attempt = 1;
  PlayPhase _phase = PlayPhase.playing;
  CompletionView? _completion;
  PuzzleNotifier(
    Board initial, {
    MemoryBests? bests,
    int? moveLimit,
    int Function()? onWin,
    Future<void> Function(Board)? persist,
    void Function(GameCue)? effect,
    String paletteId = 'classic',
  }) : this._(
         GameSession(initial, moveLimit: moveLimit),
         bests,
         onWin,
         paletteId,
         persist,
         effect,
       );
  PuzzleNotifier._(
    this._session,
    this._bests,
    this._onWin,
    this._paletteId,
    this._persist,
    this._effect,
  ) : super(_snapshot(_session, PlayPhase.playing, null, _paletteId));

  static PuzzleState _snapshot(
    GameSession session,
    PlayPhase phase,
    CompletionView? completion,
    String paletteId,
  ) {
    final board = session.board;
    return PuzzleState(
      size: board.size,
      paletteId: paletteId,
      movesTaken: board.movesTaken,
      targetMoves: board.par,
      remainingMoves: session.remainingMoves,
      previewTiles: [
        for (final tile in session.initialBoard.tiles)
          _tileView(tile.copyWith(currentRotation: tile.targetRotation)),
      ],
      isSolved: board.isSolved,
      canUndo: session.canUndo && phase == PlayPhase.playing,
      phase: phase,
      completion: completion,
      tiles: [for (final tile in board.tiles) _tileView(tile)],
    );
  }

  void _publish() =>
      state = _snapshot(_session, _phase, _completion, _paletteId);

  void rotateTile(int row, int col) {
    if (_phase != PlayPhase.playing || state.isSolved) return;
    _session.rotateTile(row, col);
    if (_session.outcome == SessionOutcome.won) {
      if (_persist != null) {
        unawaited(retrySave());
      } else {
        _complete();
      }
    } else if (_session.outcome == SessionOutcome.lost) {
      _phase = PlayPhase.gameOver;
      _effect?.call(GameCue.gameOver);
    } else {
      _effect?.call(GameCue.rotate);
    }
    _publish();
  }

  void _complete() {
    final board = _session.board;
    _phase = PlayPhase.completing;
    _completion = CompletionView(
      attemptId: _attempt,
      moves: board.movesTaken,
      targetMoves: board.par,
      stars: StarRating.calculate(
        movesTaken: board.movesTaken,
        par: board.par,
      ).count,
      newBest: _bests?.record(board) ?? false,
      bonusAwarded: _onWin?.call() ?? 0,
    );
    _effect?.call(GameCue.success);
  }

  Future<void> retrySave() async {
    if ((_phase != PlayPhase.playing && _phase != PlayPhase.saveError) ||
        !_session.board.isSolved) {
      return;
    }
    _phase = PlayPhase.saving;
    _publish();
    try {
      await _persist?.call(_session.board);
      if (!mounted) return;
      _complete();
    } catch (_) {
      if (!mounted) return;
      _phase = PlayPhase.saveError;
    }
    _publish();
  }

  void revealResults(int attemptId) {
    if (_phase != PlayPhase.completing || _completion?.attemptId != attemptId) {
      return;
    }
    _phase = PlayPhase.results;
    _publish();
  }

  void pause() {
    if (_phase != PlayPhase.playing) return;
    _phase = PlayPhase.paused;
    _publish();
  }

  void resume() {
    if (_phase != PlayPhase.paused) return;
    _phase = PlayPhase.playing;
    _publish();
  }

  void undo() {
    if (_phase != PlayPhase.playing) return;
    _session.undo();
    _publish();
  }

  void reset() {
    if (_phase == PlayPhase.saving) return;
    _session.reset();
    _attempt++;
    _phase = PlayPhase.playing;
    _completion = null;
    _publish();
  }
}

/// Illustration data uses the same domain rotations; it has no puzzle rules.
final rotationDiagramProvider =
    StateNotifierProvider.autoDispose<RotationDiagram, TileView>(
      (ref) => RotationDiagram(),
    );

class RotationDiagram extends StateNotifier<TileView> {
  Tile _tile = const Tile(tileId: 0, row: 0, col: 0, baseMask: 6);
  RotationDiagram()
    : super(_tileView(const Tile(tileId: 0, row: 0, col: 0, baseMask: 6)));
  void advance() {
    _tile = _tile.rotateClockwise();
    state = _tileView(_tile);
  }
}

final networkDiagramProvider = Provider<List<TileView>>((ref) {
  final board = TutorialBoards.lesson(0);
  return [
    for (final tile in board.tiles)
      _tileView(tile.copyWith(currentRotation: tile.targetRotation)),
  ];
});

final challengeProgressProvider = Provider((ref) {
  final snapshot = ref.watch(progressSnapshotProvider);
  return ChallengeProgress(
    completed: snapshot.wins.map((w) => w.levelId),
    bonuses: {
      for (final w in snapshot.wins)
        if (w.nextId != null) w.nextId!: w.reward,
    },
  );
});

Future<void> Function(Board)? _persistence(
  ProgressDatabase? database, [
  ChallengeLevel? level,
]) {
  if (database == null) return null;
  final generation = database.generation;
  return (board) => database.saveWin(
    generation: generation,
    size: board.size,
    seed: board.seed,
    version: board.generatorVersion,
    moves: board.movesTaken,
    stars: StarRating.calculate(
      movesTaken: board.movesTaken,
      par: board.par,
    ).count,
    levelId: level?.id,
    nextId: level?.nextId,
    reward: ChallengeRules.nextLevelReward,
  );
}

final challengeBoardFactoryProvider = Provider<Board Function(ChallengeLevel)>(
  (ref) =>
      (level) => level.generate(),
);
PatternView _pattern(
  ChallengeLevel level,
  Board board,
  ChallengeProgress progress,
  MemoryBests bests,
) => PatternView(
  id: level.id,
  stars: bests.starsFor(board),
  bestMoves: bests.movesFor(board.size, board.seed, board.generatorVersion),
  paletteId: level.paletteId,
  tier: level.tier.name,
  number: level.number,
  size: level.size,
  baseMoves: ChallengeRules.baseAllowance(board, level.tier),
  bonusMoves: progress.bonusFor(level.id),
  nextId: level.nextId,
  tiles: [
    for (final tile in board.tiles)
      _tileView(tile.copyWith(currentRotation: tile.targetRotation)),
  ],
);
// Views are refreshed after wins; preview pages re-read the session ledger on entry.
final patternCatalogProvider = Provider.autoDispose
    .family<List<PatternView>, String>((ref, tier) {
      final progress = ref.watch(challengeProgressProvider);
      final factory = ref.watch(challengeBoardFactoryProvider);
      return [
        for (final level in ChallengeCatalog.levels)
          if (level.tier.name == tier)
            _pattern(
              level,
              factory(level),
              progress,
              ref.watch(memoryBestsProvider),
            ),
      ];
    });
final patternViewProvider = Provider.autoDispose.family<PatternView?, String>((
  ref,
  id,
) {
  final level = ChallengeCatalog.find(id);
  return level == null
      ? null
      : _pattern(
          level,
          ref.watch(challengeBoardFactoryProvider)(level),
          ref.watch(challengeProgressProvider),
          ref.watch(memoryBestsProvider),
        );
});
final challengePuzzleProvider = StateNotifierProvider.autoDispose
    .family<PuzzleNotifier, PuzzleState, String>((ref, id) {
      final level = ChallengeCatalog.find(id);
      if (level == null) throw ArgumentError.value(id, 'id');
      final board = ref.watch(challengeBoardFactoryProvider)(level);
      final progress = ref.read(challengeProgressProvider);
      return PuzzleNotifier(
        board,
        paletteId: level.paletteId,
        persist: _persistence(ref.read(progressDatabaseProvider), level),
        effect: (cue) => unawaited(ref.read(gameEffectsProvider)?.play(cue)),
        bests: ref.read(memoryBestsProvider),
        moveLimit:
            ChallengeRules.baseAllowance(board, level.tier) +
            progress.bonusFor(id),
        onWin: () {
          final reward = progress.recordWin(level);
          // Mutating the ledger does not replace an active gameplay session.
          ref.invalidate(patternViewProvider);
          ref.invalidate(patternCatalogProvider);
          return reward;
        },
      );
    });
