import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../engine/content/tutorial_boards.dart';
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

/// App-session only. Tutorial boards never enter this record store.
class MemoryBests {
  final Map<(int, int, int), int> _moves = {};
  bool record(Board board) {
    final key = (board.size, board.seed, board.generatorVersion);
    final previous = _moves[key];
    if (previous != null && previous <= board.movesTaken) return false;
    _moves[key] = board.movesTaken;
    return true;
  }

  int? movesFor(int size, int seed, int version) =>
      _moves[(size, seed, version)];
}

final memoryBestsProvider = Provider((ref) => MemoryBests());
final puzzleProvider = StateNotifierProvider.autoDispose
    .family<PuzzleNotifier, PuzzleState, (int, int)>(
      (ref, key) => PuzzleNotifier(
        ref.watch(puzzleBoardFactoryProvider)(key.$1, key.$2),
        bests: key.$2 < 0 ? null : ref.read(memoryBestsProvider),
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
  int _attempt = 1;
  PlayPhase _phase = PlayPhase.playing;
  CompletionView? _completion;
  PuzzleNotifier(Board initial, {MemoryBests? bests})
    : this._(GameSession(initial), bests);
  PuzzleNotifier._(this._session, this._bests)
    : super(_snapshot(_session, PlayPhase.playing, null));

  static PuzzleState _snapshot(
    GameSession session,
    PlayPhase phase,
    CompletionView? completion,
  ) {
    final board = session.board;
    return PuzzleState(
      size: board.size,
      movesTaken: board.movesTaken,
      targetMoves: board.par,
      isSolved: board.isSolved,
      canUndo: session.canUndo && phase == PlayPhase.playing,
      phase: phase,
      completion: completion,
      tiles: [for (final tile in board.tiles) _tileView(tile)],
    );
  }

  void _publish() => state = _snapshot(_session, _phase, _completion);

  void rotateTile(int row, int col) {
    if (_phase != PlayPhase.playing || state.isSolved) return;
    _session.rotateTile(row, col);
    final board = _session.board;
    if (board.isSolved) {
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
      );
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
