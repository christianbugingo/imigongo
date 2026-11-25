/// Display-only values. Widgets never receive mutable sessions or domain boards.
class TileView {
  final int row, col, mask;
  final bool north, east, south, west;
  const TileView({
    required this.row,
    required this.col,
    required this.mask,
    required this.north,
    required this.east,
    required this.south,
    required this.west,
  });
}

class PuzzleState {
  final int size, movesTaken;
  final bool isSolved, canUndo;
  final List<TileView> tiles;
  PuzzleState({
    required this.size,
    required this.movesTaken,
    required this.isSolved,
    required this.canUndo,
    required List<TileView> tiles,
  }) : tiles = List.unmodifiable(tiles);
}
