import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/generator/puzzle_generator.dart';
import 'package:imigongo_pattern_puzzle/engine/validator/puzzle_validator.dart';
import 'package:imigongo_pattern_puzzle/models/puzzle_enums.dart';

void main() {
  group('Procedural Puzzle Generator Tests', () {
    test('Generates boards for all sizes 3x3 through 7x7', () {
      for (final dim in GridDimension.values) {
        final board = PuzzleGenerator.generate(size: dim.size, seed: 1000 + dim.size);
        expect(board.size, equals(dim.size));
        expect(board.totalTiles, equals(dim.totalTiles));
        expect(board.generatorVersion, equals(PuzzleGenerator.generatorVersion));
        expect(board.seed, equals(1000 + dim.size));
        expect(board.par, greaterThan(0));
      }
    });

    test('Generation is 100% deterministic with identical seed', () {
      final boardA = PuzzleGenerator.generate(size: 4, seed: 54321);
      final boardB = PuzzleGenerator.generate(size: 4, seed: 54321);

      expect(boardA.par, equals(boardB.par));
      expect(boardA.tiles.length, equals(boardB.tiles.length));

      for (int i = 0; i < boardA.tiles.length; i++) {
        expect(boardA.tiles[i].effectiveMask, equals(boardB.tiles[i].effectiveMask));
        expect(boardA.tiles[i].currentRotation, equals(boardB.tiles[i].currentRotation));
        expect(boardA.tiles[i].targetRotation, equals(boardB.tiles[i].targetRotation));
      }
    });

    test('Different seeds produce different boards', () {
      final boardA = PuzzleGenerator.generate(size: 4, seed: 111);
      final boardB = PuzzleGenerator.generate(size: 4, seed: 999);

      final masksA = boardA.tiles.map((t) => t.effectiveMask).toList();
      final masksB = boardB.tiles.map((t) => t.effectiveMask).toList();

      expect(masksA, isNot(equals(masksB)));
    });

    test('Newly generated board is not solved in scrambled state', () {
      final board = PuzzleGenerator.generate(size: 3, seed: 777);
      expect(board.isSolved, isFalse);
    });

    test('Applying clockwise restoration taps yields a rule-valid solved board', () {
      final board = PuzzleGenerator.generate(size: 4, seed: 8888);
      expect(board.isSolved, isFalse);

      // Restore each tile to its target rotation by applying clockwiseDistanceToTarget taps
      var currentBoard = board;
      for (int r = 0; r < currentBoard.size; r++) {
        for (int c = 0; c < currentBoard.size; c++) {
          final taps = currentBoard.tileAt(r, c).clockwiseDistanceToTarget;
          for (int t = 0; t < taps; t++) {
            currentBoard = currentBoard.rotateTile(r, c);
          }
        }
      }

      // Board must now satisfy all geometric rules without comparing to target!
      final validation = PuzzleValidator.validate(currentBoard);
      expect(validation.isValid, isTrue,
          reason: 'Restored board must pass rule-based validation');
      expect(currentBoard.isSolved, isTrue);
    });
  });
}
