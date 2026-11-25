import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/content/tutorial_boards.dart';

void main() {
  test('all three authored lessons solve through ordinary clockwise moves', () {
    for (var index = 0; index < 3; index++) {
      final initial = TutorialBoards.lesson(index);
      expect(initial.isSolved, isFalse);
      expect(initial.generatorVersion, 0);
      var board = initial;
      for (final tile in initial.tiles) {
        for (var t = 0; t < tile.clockwiseDistanceToTarget; t++) {
          board = board.rotateTile(tile.row, tile.col);
        }
      }
      expect(board.isSolved, isTrue);
      expect(board.movesTaken, initial.par);
    }
    expect(TutorialBoards.lesson(0).par, 1);
  });
}
