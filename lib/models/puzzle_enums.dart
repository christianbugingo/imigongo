/// Grid dimensions supported by the Imigongo puzzle engine (3x3 through 7x7).
enum GridDimension {
  threeByThree(3, '3x3 (Beginner)'),
  fourByFour(4, '4x4 (Intermediate)'),
  fiveByFive(5, '5x5 (Advanced)'),
  sixBySix(6, '6x6 (Expert)'),
  sevenBySeven(7, '7x7 (Master)');

  final int size;
  final String label;
  const GridDimension(this.size, this.label);

  int get totalTiles => size * size;

  static GridDimension fromSize(int size) {
    return GridDimension.values.firstWhere(
      (d) => d.size == size,
      orElse: () => GridDimension.threeByThree,
    );
  }
}

/// Difficulty levels mapping to board size and scramble complexity.
enum Difficulty {
  easy('Easy', 3, 5),
  medium('Medium', 4, 10),
  hard('Hard', 5, 16),
  expert('Expert', 6, 22),
  master('Master', 7, 28);

  final String label;
  final int defaultGridSize;
  final int defaultScrambleDepth;

  const Difficulty(this.label, this.defaultGridSize, this.defaultScrambleDepth);
}

/// Discrete quarter-turn rotations for puzzle tiles (Clockwise).
/// Controls are strictly clockwise taps; each tap rotates +90 degrees.
enum TileRotation {
  rot0(0),
  rot90(1),
  rot180(2),
  rot270(3);

  final int quarterTurns;
  const TileRotation(this.quarterTurns);

  int get degrees => quarterTurns * 90;

  /// Returns the rotation resulting from rotating 90 degrees clockwise (1 tap).
  TileRotation rotateClockwise() {
    return TileRotation.values[(index + 1) % 4];
  }

  /// Returns the rotation resulting from rotating 90 degrees counter-clockwise.
  TileRotation rotateCounterClockwise() {
    return TileRotation.values[(index + 3) % 4];
  }

  static TileRotation fromQuarterTurns(int turns) {
    final normalized = ((turns % 4) + 4) % 4;
    return TileRotation.values[normalized];
  }
}

/// Performance status of the target moves solver.
enum SolverStatus {
  /// Proved mathematically optimal within the bounded time-box.
  exactOptimal,

  /// Time-box elapsed or grid too large (e.g. 7x7); safe fallback to generator Par.
  fallbackPar,

  /// Solver execution was stopped due to timeout or resource constraint.
  timeout,
}

/// Star ratings earned upon level completion.
///
/// Par counts clockwise taps only because in-game controls are clockwise-only.
/// - 3 Stars: movesTaken <= Par
/// - 2 Stars: movesTaken <= floor(Par * 1.5)
/// - 1 Star:  movesTaken > floor(Par * 1.5)
/// Note on edge cases: When floor(Par * 1.5) == Par (e.g. Par = 1), any move count > Par
/// automatically yields 1 star, as no intermediate whole-number move count exists.
enum StarRating {
  zero(0),
  one(1),
  two(2),
  three(3);

  final int count;
  const StarRating(this.count);

  static StarRating calculate({required int movesTaken, required int par}) {
    if (movesTaken <= 0 || par <= 0) return StarRating.zero;
    if (movesTaken <= par) {
      return StarRating.three;
    }
    final twoStarThreshold = (par * 1.5).floor();
    if (movesTaken <= twoStarThreshold) {
      return StarRating.two;
    }
    return StarRating.one;
  }
}
