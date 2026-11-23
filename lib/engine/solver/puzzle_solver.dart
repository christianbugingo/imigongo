import 'dart:core';
import '../../models/puzzle_enums.dart';
import '../models/board.dart';
import '../models/tile.dart';
import '../validator/puzzle_validator.dart';

/// Result from running the offline time-boxed puzzle solver.
class SolverResult {
  final SolverStatus status;

  /// The verified target move count (either proven exact optimal or fallback Par).
  final int targetMoves;

  final int elapsedMs;
  final int nodesEvaluated;
  final bool isProvablyOptimal;

  const SolverResult({
    required this.status,
    required this.targetMoves,
    required this.elapsedMs,
    required this.nodesEvaluated,
    required this.isProvablyOptimal,
  });
}

/// Offline minimum-move solver for Imigongo puzzles.
///
/// Runs ONLY at content-generation time (in developer tooling or offline CI scripts),
/// NEVER on the player's UI thread during active gameplay.
///
/// Constrained by ADR 001's strict time-box budget (default <= 50ms).
/// If combinatorial explosion prevents proving optimality within the budget (especially
/// on 6x6 or 7x7 boards), safely falls back to the generator's Par.
class PuzzleSolver {
  PuzzleSolver._();

  /// Solves or verifies the target move count for [board] within [timeboxMs].
  static SolverResult solve({
    required Board board,
    int timeboxMs = 50,
  }) {
    final stopwatch = Stopwatch()..start();

    // Collect tiles that are not yet in their target rotation
    final scrambledIndices = <int>[];
    for (int i = 0; i < board.tiles.length; i++) {
      if (!board.tiles[i].isAtTargetRotation) {
        scrambledIndices.add(i);
      }
    }

    // Baseline: Generator's Par
    int bestMoves = board.par;
    int nodesEvaluated = 0;
    bool timedOut = false;

    // For larger boards (e.g. 6x6, 7x7) with many scrambled tiles, search space is astronomical:
    // 4^M states. If M > 12, an exhaustive branch-and-bound cannot finish in 50ms.
    if (scrambledIndices.length > 12) {
      stopwatch.stop();
      return SolverResult(
        status: SolverStatus.fallbackPar,
        targetMoves: board.par,
        elapsedMs: stopwatch.elapsedMilliseconds,
        nodesEvaluated: 1,
        isProvablyOptimal: false,
      );
    }

    // Branch and Bound search over tile rotation space
    final currentRotations = List<int>.generate(
      board.tiles.length,
      (i) => board.tiles[i].currentRotation.quarterTurns,
    );

    void search(int depthIndex, int currentTaps) {
      nodesEvaluated++;

      // Check time-box
      if (stopwatch.elapsedMilliseconds >= timeboxMs) {
        timedOut = true;
        return;
      }

      // Pruning: if current taps already exceed or equal bestMoves, prune branch
      if (currentTaps >= bestMoves) {
        return;
      }

      // If all scrambled tiles have been assigned a rotation, test validity
      if (depthIndex == scrambledIndices.length) {
        final testTiles = List<Tile>.generate(board.tiles.length, (i) {
          final original = board.tiles[i];
          final r = TileRotation.fromQuarterTurns(currentRotations[i]);
          return original.copyWith(currentRotation: r);
        });
        final testBoard = board.copyWith(tiles: testTiles);

        if (PuzzleValidator.isSolved(testBoard)) {
          if (currentTaps < bestMoves) {
            bestMoves = currentTaps;
          }
        }
        return;
      }

      final tileIdx = scrambledIndices[depthIndex];
      final originalTurns = board.tiles[tileIdx].currentRotation.quarterTurns;

      // Try 0, 1, 2, 3 clockwise taps
      for (int tap = 0; tap < 4; tap++) {
        if (timedOut) return;

        currentRotations[tileIdx] = (originalTurns + tap) % 4;
        search(depthIndex + 1, currentTaps + tap);
      }

      // Backtrack
      currentRotations[tileIdx] = originalTurns;
    }

    search(0, 0);
    stopwatch.stop();

    if (timedOut) {
      return SolverResult(
        status: SolverStatus.fallbackPar,
        targetMoves: board.par,
        elapsedMs: stopwatch.elapsedMilliseconds,
        nodesEvaluated: nodesEvaluated,
        isProvablyOptimal: false,
      );
    }

    return SolverResult(
      status: SolverStatus.exactOptimal,
      targetMoves: bestMoves,
      elapsedMs: stopwatch.elapsedMilliseconds,
      nodesEvaluated: nodesEvaluated,
      isProvablyOptimal: true,
    );
  }
}
