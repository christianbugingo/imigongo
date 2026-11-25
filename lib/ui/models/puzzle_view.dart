/// Display-only values; all gameplay calculations stay behind the controller.
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

enum PlayPhase { playing, paused, completing, results }

class CompletionView {
  final int attemptId, moves, targetMoves, stars;
  final bool newBest;
  const CompletionView({
    required this.attemptId,
    required this.moves,
    required this.targetMoves,
    required this.stars,
    required this.newBest,
  });
}

class PuzzleState {
  final int size, movesTaken, targetMoves;
  final bool isSolved, canUndo;
  final PlayPhase phase;
  final CompletionView? completion;
  final List<TileView> tiles;
  PuzzleState({
    required this.size,
    required this.movesTaken,
    required this.targetMoves,
    required this.isSolved,
    required this.canUndo,
    required this.phase,
    this.completion,
    required List<TileView> tiles,
  }) : tiles = List.unmodifiable(tiles);
}
