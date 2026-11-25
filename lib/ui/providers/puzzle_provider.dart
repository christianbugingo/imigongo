import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../engine/generator/puzzle_generator.dart';
import '../../engine/models/board.dart';
import '../../engine/models/connection_mask.dart';
import '../../engine/models/game_session.dart';
import '../models/puzzle_view.dart';

/// Replaceable input for controller tests and future authored content.
final puzzleBoardFactoryProvider = Provider<Board Function(int, int)>((ref) {
  return (size, seed) => PuzzleGenerator.generate(size: size, seed: seed);
});

final puzzleProvider = StateNotifierProvider.autoDispose
    .family<PuzzleNotifier, PuzzleState, (int, int)>((ref, key) {
      final factory = ref.watch(puzzleBoardFactoryProvider);
      return PuzzleNotifier(factory(key.$1, key.$2));
    });

/// The sole adapter between gameplay widgets and the pure Dart engine.
class PuzzleNotifier extends StateNotifier<PuzzleState> {
  final GameSession _session;
  PuzzleNotifier(Board initial) : this._(GameSession(initial));
  PuzzleNotifier._(this._session) : super(_snapshot(_session));

  static PuzzleState _snapshot(GameSession session) {
    final board = session.board;
    return PuzzleState(
      size: board.size,
      movesTaken: board.movesTaken,
      isSolved: board.isSolved,
      canUndo: session.canUndo,
      tiles: [
        for (final tile in board.tiles)
          TileView(
            row: tile.row,
            col: tile.col,
            mask: tile.effectiveMask,
            north: ConnectionMask.hasNorth(tile.effectiveMask),
            east: ConnectionMask.hasEast(tile.effectiveMask),
            south: ConnectionMask.hasSouth(tile.effectiveMask),
            west: ConnectionMask.hasWest(tile.effectiveMask),
          ),
      ],
    );
  }

  void rotateTile(int row, int col) {
    if (state.isSolved) return;
    _session.rotateTile(row, col);
    state = _snapshot(_session);
  }

  void undo() {
    _session.undo();
    state = _snapshot(_session);
  }

  void reset() {
    _session.reset();
    state = _snapshot(_session);
  }
}
