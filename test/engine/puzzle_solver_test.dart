import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/generator/puzzle_generator.dart';
import 'package:imigongo_pattern_puzzle/engine/models/board.dart';
import 'package:imigongo_pattern_puzzle/engine/models/connection_mask.dart';
import 'package:imigongo_pattern_puzzle/engine/models/tile.dart';

import '../../tool/solver/puzzle_solver.dart';

import 'package:imigongo_pattern_puzzle/models/puzzle_enums.dart';

void main() {
  group('Time-Boxed Offline Puzzle Solver Tests', () {
    test('Small 3x3 board proves exact optimal moves within time-box', () {
      // 3x3 board where exactly one tile is scrambled by 1 clockwise turn
      final tiles = <Tile>[
        // (0,0) is rotated 1 turn CW: needs 3 CW taps to restore
        const Tile(
          tileId: 0,
          row: 0,
          col: 0,
          baseMask: ConnectionMask.cornerEastSouth,
          currentRotation: TileRotation.rot90,
          targetRotation: TileRotation.rot0,
        ),
        const Tile(
          tileId: 1,
          row: 0,
          col: 1,
          baseMask: ConnectionMask.cornerSouthWest,
        ),
        const Tile(tileId: 2, row: 0, col: 2, baseMask: ConnectionMask.none),

        const Tile(
          tileId: 3,
          row: 1,
          col: 0,
          baseMask: ConnectionMask.cornerNorthEast,
        ),
        const Tile(
          tileId: 4,
          row: 1,
          col: 1,
          baseMask: ConnectionMask.cornerWestNorth,
        ),
        const Tile(tileId: 5, row: 1, col: 2, baseMask: ConnectionMask.none),

        const Tile(tileId: 6, row: 2, col: 0, baseMask: ConnectionMask.none),
        const Tile(tileId: 7, row: 2, col: 1, baseMask: ConnectionMask.none),
        const Tile(tileId: 8, row: 2, col: 2, baseMask: ConnectionMask.none),
      ];

      final board = Board(
        size: 3,
        tiles: tiles,
        seed: 42,
        generatorVersion: 1,
        par: 3,
      );

      final result = PuzzleSolver.solve(board: board, timeboxMs: 50);

      expect(result.status, equals(SolverStatus.exactOptimal));
      expect(result.targetMoves, equals(3));
      expect(result.isProvablyOptimal, isTrue);
      expect(result.elapsedMs, lessThanOrEqualTo(50));
    });

    test('Zero budget returns unproven generator Par', () {
      final board = PuzzleGenerator.generate(
        size: 7,
        seed: 99999,
        targetScrambleTaps: 25,
      );

      final result = PuzzleSolver.solve(board: board, timeboxMs: 0);

      expect(result.status, equals(SolverStatus.fallbackPar));
      expect(result.targetMoves, equals(board.par));
      // Invariant: Never label an unproven number as exact minimum
      expect(result.isProvablyOptimal, isFalse);
      expect(result.elapsedMs, lessThanOrEqualTo(50));
    });

    test('Solver honors time-box cutoff even on intermediate grids', () {
      final board = PuzzleGenerator.generate(
        size: 6,
        seed: 88888,
        targetScrambleTaps: 20,
      );

      final result = PuzzleSolver.solve(board: board, timeboxMs: 50);

      // Must terminate cleanly within the 50ms budget
      expect(result.elapsedMs, lessThanOrEqualTo(100));
      if (!result.isProvablyOptimal) {
        expect(result.status, equals(SolverStatus.fallbackPar));
        expect(result.targetMoves, equals(board.par));
      }
    });
  });
}
