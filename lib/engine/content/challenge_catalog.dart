import '../generator/puzzle_generator.dart';
import '../generator/center_network_generator.dart';
import '../models/board.dart';

part 'challenge_levels.g.dart';

enum ChallengeTier { easy, medium, hard }

class ChallengeLevel {
  final String id;
  final int number, size, seed;
  final int generatorVersion;
  final String paletteId;
  final ChallengeTier tier;
  final String? nextId;
  const ChallengeLevel(
    this.id,
    this.number,
    this.size,
    this.seed,
    this.tier,
    this.nextId, {
    this.generatorVersion = 2,
    this.paletteId = 'classic',
  });
  Board generate() => switch (generatorVersion) {
    2 => PuzzleGenerator.generate(size: size, seed: seed),
    3 => CenterNetworkGenerator.generate(size: size, seed: seed),
    _ => throw StateError('Unsupported generator version: $generatorVersion'),
  };
}

/// Fifty stable, versioned levels; difficulty groups keep their own next chains.
class ChallengeCatalog {
  static const levels = _challengeLevels;
  static ChallengeLevel? find(String id) {
    for (final level in levels) {
      if (level.id == id) return level;
    }
    return null;
  }
}
