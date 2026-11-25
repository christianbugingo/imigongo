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

enum PlayPhase { playing, paused, completing, results, gameOver }

class CompletionView {
  final int attemptId, moves, targetMoves, stars;
  final bool newBest;
  final int bonusAwarded;
  const CompletionView({
    required this.attemptId,
    required this.moves,
    required this.targetMoves,
    required this.stars,
    required this.newBest,
    this.bonusAwarded = 0,
  });
}

class PuzzleState {
  final int size, movesTaken, targetMoves;
  final String paletteId;
  final int? remainingMoves;
  final List<TileView> previewTiles;
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
    this.paletteId = 'classic',
    this.remainingMoves,
    List<TileView> previewTiles = const [],
    this.completion,
    required List<TileView> tiles,
  }) : tiles = List.unmodifiable(tiles),
       previewTiles = List.unmodifiable(previewTiles);
}

class PatternView {
  final String id, tier;
  final String paletteId;
  final String? nextId;
  final int number, size, baseMoves, bonusMoves;
  final List<TileView> tiles;
  PatternView({
    required this.id,
    this.paletteId = 'classic',
    required this.tier,
    required this.number,
    required this.size,
    required this.baseMoves,
    required this.bonusMoves,
    required this.nextId,
    required List<TileView> tiles,
  }) : tiles = List.unmodifiable(tiles);
}
