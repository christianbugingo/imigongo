import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/models/puzzle_enums.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/puzzle_provider.dart';

void main() {
  group('PuzzleProvider Riverpod State Tests', () {
    test('Initializes scrambled puzzle state with movesTaken = 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(puzzleProvider((3, 101)));
      expect(state.board.size, equals(3));
      expect(state.board.movesTaken, equals(0));
      expect(state.isSolved, isFalse);
      expect(state.hasWon, isFalse);
      expect(state.stars, equals(StarRating.zero));
    });

    test('rotateTile advances movesTaken and triggers rule evaluation', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(puzzleProvider((3, 202)).notifier);
      notifier.rotateTile(0, 0);

      final state = container.read(puzzleProvider((3, 202)));
      expect(state.board.movesTaken, equals(1));
    });

    test('reset restores initial state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(puzzleProvider((3, 303)).notifier);
      notifier.rotateTile(0, 0);
      notifier.rotateTile(1, 1);
      expect(container.read(puzzleProvider((3, 303))).board.movesTaken, equals(2));

      notifier.reset();
      final resetState = container.read(puzzleProvider((3, 303)));
      expect(resetState.board.movesTaken, equals(0));
      expect(resetState.hasWon, isFalse);
    });
  });
}

