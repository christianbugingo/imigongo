import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/models/board.dart';
import 'package:imigongo_pattern_puzzle/engine/models/connection_mask.dart';
import 'package:imigongo_pattern_puzzle/engine/models/tile.dart';
import 'package:imigongo_pattern_puzzle/engine/validator/puzzle_validator.dart';
import 'package:imigongo_pattern_puzzle/models/puzzle_enums.dart';

void main() {
  group('Rule-Based Puzzle Validator Tests', () {
    test('Valid 2x2 loop satisfies all geometric continuity rules', () {
      // Create a 3x3 board where the top-left 2x2 forms a closed loop:
      // (0,0): Corner East-South (6)
      // (0,1): Corner South-West (12)
      // (1,0): Corner North-East (3)
      // (1,1): Corner West-North (9)
      // All other cells: None (0)
      final tiles = <Tile>[
        const Tile(tileId: 0, row: 0, col: 0, baseMask: ConnectionMask.cornerEastSouth),
        const Tile(tileId: 1, row: 0, col: 1, baseMask: ConnectionMask.cornerSouthWest),
        const Tile(tileId: 2, row: 0, col: 2, baseMask: ConnectionMask.none),

        const Tile(tileId: 3, row: 1, col: 0, baseMask: ConnectionMask.cornerNorthEast),
        const Tile(tileId: 4, row: 1, col: 1, baseMask: ConnectionMask.cornerWestNorth),
        const Tile(tileId: 5, row: 1, col: 2, baseMask: ConnectionMask.none),

        const Tile(tileId: 6, row: 2, col: 0, baseMask: ConnectionMask.none),
        const Tile(tileId: 7, row: 2, col: 1, baseMask: ConnectionMask.none),
        const Tile(tileId: 8, row: 2, col: 2, baseMask: ConnectionMask.none),
      ];

      final board = Board(
        size: 3,
        tiles: tiles,
        seed: 1,
        generatorVersion: 1,
        par: 0,
      );

      final result = PuzzleValidator.validate(board);
      expect(result.isValid, isTrue);
      expect(result.brokenEdgesCount, equals(0));
      expect(result.totalActiveEdges, equals(8)); // 4 tiles with 2 edges each = 8
    });

    test('Detects broken horizontal edge mismatch', () {
      // (0,0) has East, but (0,1) does NOT have West
      final tiles = <Tile>[
        const Tile(tileId: 0, row: 0, col: 0, baseMask: ConnectionMask.cornerEastSouth),
        const Tile(tileId: 1, row: 0, col: 1, baseMask: ConnectionMask.lineNorthSouth), // broken!
        const Tile(tileId: 2, row: 0, col: 2, baseMask: ConnectionMask.none),

        const Tile(tileId: 3, row: 1, col: 0, baseMask: ConnectionMask.cornerNorthEast),
        const Tile(tileId: 4, row: 1, col: 1, baseMask: ConnectionMask.cornerWestNorth),
        const Tile(tileId: 5, row: 1, col: 2, baseMask: ConnectionMask.none),

        const Tile(tileId: 6, row: 2, col: 0, baseMask: ConnectionMask.none),
        const Tile(tileId: 7, row: 2, col: 1, baseMask: ConnectionMask.none),
        const Tile(tileId: 8, row: 2, col: 2, baseMask: ConnectionMask.none),
      ];

      final board = Board(
        size: 3,
        tiles: tiles,
        seed: 1,
        generatorVersion: 1,
        par: 1,
      );

      final result = PuzzleValidator.validate(board);
      expect(result.isValid, isFalse);
      expect(result.brokenEdgesCount, greaterThan(0));
      expect(result.firstDiscontinuityReason, contains('Horizontal edge mismatch'));
    });

    test('Detects path escaping outer boundary', () {
      // (0,0) has North connection escaping top boundary
      final tiles = <Tile>[
        const Tile(tileId: 0, row: 0, col: 0, baseMask: ConnectionMask.lineNorthSouth), // North escapes!
        const Tile(tileId: 1, row: 0, col: 1, baseMask: ConnectionMask.none),
        const Tile(tileId: 2, row: 0, col: 2, baseMask: ConnectionMask.none),

        const Tile(tileId: 3, row: 1, col: 0, baseMask: ConnectionMask.lineNorthSouth),
        const Tile(tileId: 4, row: 1, col: 1, baseMask: ConnectionMask.none),
        const Tile(tileId: 5, row: 1, col: 2, baseMask: ConnectionMask.none),

        const Tile(tileId: 6, row: 2, col: 0, baseMask: ConnectionMask.none),
        const Tile(tileId: 7, row: 2, col: 1, baseMask: ConnectionMask.none),
        const Tile(tileId: 8, row: 2, col: 2, baseMask: ConnectionMask.none),
      ];

      final board = Board(
        size: 3,
        tiles: tiles,
        seed: 1,
        generatorVersion: 1,
        par: 1,
      );

      final result = PuzzleValidator.validate(board);
      expect(result.isValid, isFalse);
      expect(result.firstDiscontinuityReason, contains('escaping top boundary'));
    });

    test('Rejects trivial empty board with no active paths', () {
      final tiles = List.generate(
        9,
        (i) => Tile(tileId: i, row: i ~/ 3, col: i % 3, baseMask: ConnectionMask.none),
      );

      final board = Board(
        size: 3,
        tiles: tiles,
        seed: 1,
        generatorVersion: 1,
        par: 0,
      );

      final result = PuzzleValidator.validate(board);
      expect(result.isValid, isFalse);
      expect(result.firstDiscontinuityReason, contains('trivial'));
    });

    test('Accepts alternative valid rotation not matching stored target rotation', () {
      // Straight line tile with baseMask: lineNorthSouth (5)
      // In base orientation, it connects North-South.
      // If targetRotation was rot0, but we test rot180 (2 quarter turns),
      // the mask is still lineNorthSouth (5).
      // The validator should accept it as valid by rules, even if rotation != targetRotation.
      const tile0 = Tile(
        tileId: 0,
        row: 0,
        col: 0,
        baseMask: ConnectionMask.cornerEastSouth,
      );
      const tile1 = Tile(
        tileId: 1,
        row: 0,
        col: 1,
        baseMask: ConnectionMask.cornerSouthWest,
      );
      // tile3 with a straight line that connects vertically, rotated 180 degrees
      const tile3 = Tile(
        tileId: 3,
        row: 1,
        col: 0,
        baseMask: ConnectionMask.cornerNorthEast,
        currentRotation: TileRotation.rot0,
        targetRotation: TileRotation.rot90, // target is different!
      );
      const tile4 = Tile(
        tileId: 4,
        row: 1,
        col: 1,
        baseMask: ConnectionMask.cornerWestNorth,
      );

      final tiles = <Tile>[
        tile0, tile1, const Tile(tileId: 2, row: 0, col: 2, baseMask: 0),
        tile3, tile4, const Tile(tileId: 5, row: 1, col: 2, baseMask: 0),
        const Tile(tileId: 6, row: 2, col: 0, baseMask: 0),
        const Tile(tileId: 7, row: 2, col: 1, baseMask: 0),
        const Tile(tileId: 8, row: 2, col: 2, baseMask: 0),
      ];

      final board = Board(
        size: 3,
        tiles: tiles,
        seed: 1,
        generatorVersion: 1,
        par: 2,
      );

      // Even though tile3 currentRotation != targetRotation, the board is structurally valid!
      expect(PuzzleValidator.isSolved(board), isTrue);
    });
  });
}
