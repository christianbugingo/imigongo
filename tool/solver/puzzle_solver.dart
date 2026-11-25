import 'package:imigongo_pattern_puzzle/engine/models/board.dart';
import 'package:imigongo_pattern_puzzle/engine/models/connection_mask.dart';
import 'package:imigongo_pattern_puzzle/engine/models/tile.dart';
import 'package:imigongo_pattern_puzzle/models/puzzle_enums.dart';

class SolverResult {
  final SolverStatus status;
  final int targetMoves, elapsedMs, nodesEvaluated;
  bool get isProvablyOptimal => status == SolverStatus.exactOptimal;
  const SolverResult({
    required this.status,
    required this.targetMoves,
    required this.elapsedMs,
    required this.nodesEvaluated,
  });
}

/// Exhaustive branch-and-bound over ALL distinct tile orientations, tool only.
class PuzzleSolver {
  static SolverResult solve({required Board board, int timeboxMs = 50}) {
    if (timeboxMs < 0 || timeboxMs > 50) {
      throw ArgumentError.value(
        timeboxMs,
        'timeboxMs',
        'Must be 0..50 (ADR 001)',
      );
    }
    final watch = Stopwatch()..start();
    var best = board.remainingClockwiseTapsToTarget;
    final restored = board.copyWith(
      tiles: [
        for (final t in board.tiles)
          t.copyWith(currentRotation: t.targetRotation),
      ],
    );
    if (!restored.isSolved) throw ArgumentError('Generator target is invalid');
    var timedOut = false;
    var nodes = 0;
    final assigned = List<Tile>.of(board.tiles);
    void search(int index, int cost) {
      nodes++;
      if (watch.elapsedMicroseconds >= timeboxMs * 1000) {
        timedOut = true;
        return;
      }
      if (cost >= best) return;
      if (index == assigned.length) {
        if (board.copyWith(tiles: assigned).isSolved) best = cost;
        return;
      }
      final original = board.tiles[index];
      final seen = <int>{};
      for (var taps = 0; taps < 4; taps++) {
        if (timedOut) {
          return;
        }
        final mask = ConnectionMask.rotateClockwise(
          original.effectiveMask,
          taps,
        );
        if (!seen.add(mask)) continue;
        final r = index ~/ board.size, c = index % board.size;
        if ((r == 0 && mask & 1 != 0) ||
            (c == board.size - 1 && mask & 2 != 0) ||
            (r == board.size - 1 && mask & 4 != 0) ||
            (c == 0 && mask & 8 != 0)) {
          continue;
        }
        if (c > 0 &&
            ((assigned[index - 1].effectiveMask & 2 != 0) != (mask & 8 != 0))) {
          continue;
        }
        if (r > 0 &&
            ((assigned[index - board.size].effectiveMask & 4 != 0) !=
                (mask & 1 != 0))) {
          continue;
        }
        assigned[index] = original.copyWith(
          currentRotation: TileRotation.fromQuarterTurns(
            original.currentRotation.quarterTurns + taps,
          ),
        );
        search(index + 1, cost + taps);
      }
    }

    search(0, 0);
    watch.stop();
    return SolverResult(
      status: timedOut ? SolverStatus.fallbackPar : SolverStatus.exactOptimal,
      targetMoves: timedOut ? board.par : best,
      elapsedMs: watch.elapsedMilliseconds,
      nodesEvaluated: nodes,
    );
  }
}
