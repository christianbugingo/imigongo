import '../../models/puzzle_enums.dart';
import '../models/board.dart';
import '../models/tile.dart';

/// Authored data only; the normal validator and move accounting apply unchanged.
/// generatorVersion 0 denotes authored tutorial data, never seeded generation.
class TutorialBoards {
  static Board lesson(int index) {
    RangeError.checkValueInInterval(index, 0, 2, 'index');
    final masks = <List<int>>[
      [6, 12, 0, 3, 9, 0, 0, 0, 0],
      [6, 14, 12, 7, 15, 13, 3, 11, 9],
      [6, 10, 12, 5, 0, 5, 3, 10, 9],
    ][index];
    final rotations = <Map<int, int>>[
      {0: 3},
      {1: 1, 7: 1},
      {0: 3, 2: 2},
    ][index];
    final tiles = [
      for (var i = 0; i < 9; i++)
        Tile(
          tileId: i,
          row: i ~/ 3,
          col: i % 3,
          baseMask: masks[i],
          currentRotation: TileRotation.fromQuarterTurns(rotations[i] ?? 0),
        ),
    ];
    return Board(
      size: 3,
      tiles: tiles,
      seed: index,
      generatorVersion: 0,
      par: tiles.fold(0, (sum, tile) => sum + tile.clockwiseDistanceToTarget),
    );
  }
}
