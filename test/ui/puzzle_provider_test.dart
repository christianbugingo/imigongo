import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/generator/puzzle_generator.dart';
import 'package:imigongo_pattern_puzzle/engine/models/board.dart';
import 'package:imigongo_pattern_puzzle/engine/models/tile.dart';
import 'package:imigongo_pattern_puzzle/models/puzzle_enums.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/puzzle_provider.dart';

Board oneTapBoard() => Board(
  size: 3,
  seed: 1,
  generatorVersion: 2,
  par: 1,
  tiles: [
    for (var i = 0; i < 9; i++)
      Tile(
        tileId: i,
        row: i ~/ 3,
        col: i % 3,
        baseMask: const [6, 12, 0, 3, 9, 0, 0, 0, 0][i],
        currentRotation: i == 0 ? TileRotation.rot270 : TileRotation.rot0,
        // Deliberately misleading stored targets prove rule-based solved detection.
        targetRotation: TileRotation.rot90,
      ),
  ],
);

void main() {
  const key = (3, 1);
  ProviderContainer setup(Board board) {
    final container = ProviderContainer(
      overrides: [
        puzzleBoardFactoryProvider.overrideWithValue((_, _) => board),
      ],
    );
    addTearDown(container.dispose);
    container.listen(puzzleProvider(key), (_, _) {});
    return container;
  }

  test('controller publishes engine masks, move count and solved state', () {
    final initial = oneTapBoard();
    final container = setup(initial);
    var state = container.read(puzzleProvider(key));
    expect(state.isSolved, isFalse);
    expect(state.movesTaken, 0);
    expect(state.canUndo, isFalse);
    container.read(puzzleProvider(key).notifier).rotateTile(0, 0);
    state = container.read(puzzleProvider(key));
    final engine = initial.rotateTile(0, 0);
    expect(
      state.tiles.map((t) => t.mask),
      engine.tiles.map((t) => t.effectiveMask),
    );
    expect(state.movesTaken, engine.movesTaken);
    expect(state.isSolved, engine.isSolved);
    expect(state.isSolved, isTrue);
    expect(state.canUndo, isTrue);
    expect(() => state.tiles.clear(), throwsUnsupportedError);
    // Solved input is disabled, but undo remains available.
    container.read(puzzleProvider(key).notifier).rotateTile(0, 1);
    expect(container.read(puzzleProvider(key)).movesTaken, 1);
  });

  test(
    'undo after solve restores unsolved state; reset clears engine history',
    () {
      final container = setup(oneTapBoard());
      final notifier = container.read(puzzleProvider(key).notifier);
      notifier.undo();
      notifier.rotateTile(0, 0);
      notifier.undo();
      expect(container.read(puzzleProvider(key)).isSolved, isFalse);
      expect(container.read(puzzleProvider(key)).movesTaken, 0);
      expect(container.read(puzzleProvider(key)).canUndo, isFalse);
      notifier.rotateTile(0, 1);
      notifier.rotateTile(1, 1);
      notifier.undo();
      expect(container.read(puzzleProvider(key)).movesTaken, 1);
      notifier.reset();
      final reset = container.read(puzzleProvider(key));
      expect(reset.movesTaken, 0);
      expect(reset.canUndo, isFalse);
      expect(
        reset.tiles.map((t) => t.mask),
        oneTapBoard().tiles.map((t) => t.effectiveMask),
      );
      notifier.undo();
      expect(container.read(puzzleProvider(key)).movesTaken, 0);
    },
  );

  test('invalid coordinates preserve state and history', () {
    final container = setup(oneTapBoard());
    final before = container.read(puzzleProvider(key));
    expect(
      () => container.read(puzzleProvider(key).notifier).rotateTile(0, 3),
      throwsRangeError,
    );
    expect(identical(container.read(puzzleProvider(key)), before), isTrue);
  });

  test('family instances are isolated', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(puzzleProvider((3, 101)), (_, _) {});
    container.listen(puzzleProvider((4, 101)), (_, _) {});
    container.read(puzzleProvider((3, 101)).notifier).rotateTile(0, 0);
    expect(container.read(puzzleProvider((3, 101))).movesTaken, 1);
    expect(container.read(puzzleProvider((4, 101))).movesTaken, 0);
  });

  test(
    'already solved initial board is detected rather than assumed scrambled',
    () {
      final initial = oneTapBoard().rotateTile(0, 0);
      final container = setup(initial);
      expect(container.read(puzzleProvider(key)).isSolved, isTrue);
    },
  );

  test('default factory is deterministic generator version 2', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final board = container.read(puzzleBoardFactoryProvider)(6, 42);
    expect(
      board.toJson(),
      PuzzleGenerator.generate(size: 6, seed: 42).toJson(),
    );
  });
}
