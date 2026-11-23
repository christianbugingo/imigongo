/// Constants governing puzzle generation, par rules, and solver bounds.
class EngineConstants {
  EngineConstants._();

  /// Default time-box limit (in milliseconds) for the exact minimum-move solver.
  /// If search exceeds this threshold, the engine safely falls back to generator Par.
  static const int defaultSolverTimeboxMs = 50;

  /// Multiplier applied to Par to compute 2-star move threshold.
  static const double twoStarParMultiplier = 1.5;

  /// Min grid dimension supported.
  static const int minGridSize = 3;

  /// Max grid dimension supported.
  static const int maxGridSize = 7;

  /// Minimum scrambles applied during procedural generation.
  static const int minScrambleMoves = 4;

  /// Maximum scrambles for 7x7 expert boards.
  static const int maxScrambleMoves = 30;

  /// Traditional Imigongo motif keys.
  static const String motifItana = 'itana'; // Zigzags / hearth
  static const String motifUruhembe = 'uruhembe'; // Cattle horns / diamonds
  static const String motifInyange = 'inyange'; // Triangle elegance
  static const String motifBwirande = 'bwirande'; // Concentric squares
}
