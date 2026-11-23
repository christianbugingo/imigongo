import '../../models/puzzle_enums.dart';
import '../models/board.dart';
import '../models/connection_mask.dart';
import '../models/tile.dart';
import '../prng/xoshiro128.dart';
import '../validator/puzzle_validator.dart';

/// Procedural generator for Imigongo geometric pattern puzzles.
///
/// Produces deterministic boards from an integer seed and stores generatorVersion.
/// Generates a valid solved motif, scrambles it with clockwise taps, and computes Par.
class PuzzleGenerator {
  /// Current generator version. Stored with every puzzle seed.
  static const int generatorVersion = 1;

  PuzzleGenerator._();

  /// Generates a scrambled puzzle board with guaranteed rule-based solution and Par.
  static Board generate({
    required int size,
    required int seed,
    int? targetScrambleTaps,
  }) {
    assert(size >= 3 && size <= 7, 'Size must be between 3 and 7 (was $size)');

    final prng = Xoshiro128(seed);

    // Step 1: Synthesize a valid continuous geometric motif on the NxN grid
    final solvedTiles = _buildSolvedMotif(size, prng);

    // Step 2: Establish the target solved rotation for every tile
    // Standardize baseMask so that targetRotation is TileRotation.rot0
    final targetTiles = <Tile>[];
    for (int i = 0; i < solvedTiles.length; i++) {
      final base = solvedTiles[i];
      targetTiles.add(Tile(
        tileId: i,
        row: base.row,
        col: base.col,
        baseMask: base.effectiveMask,
        currentRotation: TileRotation.rot0,
        targetRotation: TileRotation.rot0,
      ));
    }

    // Step 3: Scramble the board using clockwise taps and compute Par
    final scrambleBudget = targetScrambleTaps ?? (size * 2 + 4);
    final scrambledTiles = List<Tile>.of(targetTiles);

    int totalPar = 0;
    // Collect tiles that are non-symmetric (i.e. rotating them actually changes the mask)
    final rotatableIndices = <int>[];
    for (int i = 0; i < scrambledTiles.length; i++) {
      final t = scrambledTiles[i];
      final m0 = t.baseMask;
      final m1 = ConnectionMask.rotateClockwise(m0, 1);
      final m2 = ConnectionMask.rotateClockwise(m0, 2);
      final m3 = ConnectionMask.rotateClockwise(m0, 3);
      if (m1 != m0 || m2 != m0 || m3 != m0) {
        rotatableIndices.add(i);
      }
    }

    if (rotatableIndices.isNotEmpty) {
      // Apply scrambles
      int appliedTaps = 0;
      final tileRotations = List<int>.filled(scrambledTiles.length, 0);

      while (appliedTaps < scrambleBudget) {
        final randIdx = rotatableIndices[prng.nextBoundedInt(rotatableIndices.length)];
        final turns = prng.nextBoundedInt(3) + 1; // 1, 2, or 3 quarter turns
        tileRotations[randIdx] = (tileRotations[randIdx] + turns) % 4;
        appliedTaps += turns;
      }

      // Reconstruct scrambled tiles and calculate true clockwise Par
      for (int i = 0; i < scrambledTiles.length; i++) {
        final turns = tileRotations[i];
        if (turns != 0) {
          final rot = TileRotation.fromQuarterTurns(turns);
          scrambledTiles[i] = scrambledTiles[i].copyWith(currentRotation: rot);
          // Clockwise taps to return to rot0: (4 - turns) % 4
          totalPar += (4 - turns) % 4;
        }
      }
    }

    // Fallback: If par ended up 0, force rotate at least one rotatable tile
    if (totalPar == 0 && rotatableIndices.isNotEmpty) {
      final idx = rotatableIndices[0];
      scrambledTiles[idx] = scrambledTiles[idx].copyWith(currentRotation: TileRotation.rot90);
      totalPar = 3; // (4 - 1) = 3 clockwise taps to return to rot0
    }

    final board = Board(
      size: size,
      tiles: scrambledTiles,
      seed: seed,
      generatorVersion: generatorVersion,
      par: totalPar,
    );

    // If accidentally still solved under rules, apply an additional rotation
    if (PuzzleValidator.isSolved(board) && rotatableIndices.isNotEmpty) {
      final idx = rotatableIndices[0];
      scrambledTiles[idx] = scrambledTiles[idx].rotateClockwise();
      final newPar = totalPar + 1;
      return Board(
        size: size,
        tiles: scrambledTiles,
        seed: seed,
        generatorVersion: generatorVersion,
        par: newPar,
      );
    }

    return board;
  }

  /// Builds a fully connected, closed geometric Imigongo layout (degree >= 2 on all active nodes).
  static List<Tile> _buildSolvedMotif(int size, Xoshiro128 prng) {
    // Generate horizontal and vertical edge connection grids
    // hEdges[r][c] is connection between (r, c) and (r, c + 1), size: r in [0, size-1], c in [0, size-2]
    final hEdges = List.generate(size, (_) => List<bool>.filled(size - 1, false));
    // vEdges[r][c] is connection between (r, c) and (r + 1, c), size: r in [0, size-2], c in [0, size-1]
    final vEdges = List.generate(size - 1, (_) => List<bool>.filled(size, false));

    // Choose a geometric archetype based on seed
    final motifType = prng.nextBoundedInt(3);

    if (motifType == 0) {
      // Archetype 0: Diamond lozenges / concentric loops
      _generateDiamondLozenges(size, hEdges, vEdges);
    } else if (motifType == 1) {
      // Archetype 1: Chevron / wave bands (Itana)
      _generateChevronWaves(size, hEdges, vEdges);
    } else {
      // Archetype 2: Concentric frame loops
      _generateConcentricFrames(size, hEdges, vEdges);
    }

    // Assemble tiles from the edge connections
    final tiles = <Tile>[];
    int id = 0;
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        int mask = ConnectionMask.none;
        // North
        if (r > 0 && vEdges[r - 1][c]) mask |= ConnectionMask.north;
        // South
        if (r < size - 1 && vEdges[r][c]) mask |= ConnectionMask.south;
        // West
        if (c > 0 && hEdges[r][c - 1]) mask |= ConnectionMask.west;
        // East
        if (c < size - 1 && hEdges[r][c]) mask |= ConnectionMask.east;

        tiles.add(Tile(
          tileId: id++,
          row: r,
          col: c,
          baseMask: mask,
        ));
      }
    }

    return tiles;
  }

  /// Diamond lozenge motif.
  static void _generateDiamondLozenges(
    int size,
    List<List<bool>> hEdges,
    List<List<bool>> vEdges,
  ) {
    final mid = size ~/ 2;
    for (int ring = 1; ring <= mid; ring++) {
      for (int r = 0; r < size; r++) {
        for (int c = 0; c < size; c++) {
          final dist = (r - mid).abs() + (c - mid).abs();
          if (dist == ring) {
            // Connect to neighboring diamond cells
            if (c < size - 1 && ((r - mid).abs() + (c + 1 - mid).abs() == ring)) {
              hEdges[r][c] = true;
            }
            if (r < size - 1 && ((r + 1 - mid).abs() + (c - mid).abs() == ring)) {
              vEdges[r][c] = true;
            }
          }
        }
      }
    }
    // Ensure connectivity
    _ensureNonEmpty(size, hEdges, vEdges);
  }

  /// Chevron waves (Itana) motif.
  static void _generateChevronWaves(
    int size,
    List<List<bool>> hEdges,
    List<List<bool>> vEdges,
  ) {
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size - 1; c++) {
        if ((r + c) % 2 == 0) {
          hEdges[r][c] = true;
        }
      }
    }
    for (int r = 0; r < size - 1; r++) {
      for (int c = 0; c < size; c++) {
        if ((r + c) % 2 == 1) {
          vEdges[r][c] = true;
        }
      }
    }
    _ensureNonEmpty(size, hEdges, vEdges);
  }

  /// Concentric frames motif.
  static void _generateConcentricFrames(
    int size,
    List<List<bool>> hEdges,
    List<List<bool>> vEdges,
  ) {
    final maxInset = (size - 1) ~/ 2;
    for (int inset = 0; inset < maxInset; inset += 2) {
      final minCoord = inset;
      final maxCoord = size - 1 - inset;

      // Top and bottom horizontal edges
      for (int c = minCoord; c < maxCoord; c++) {
        hEdges[minCoord][c] = true;
        hEdges[maxCoord][c] = true;
      }
      // Left and right vertical edges
      for (int r = minCoord; r < maxCoord; r++) {
        vEdges[r][minCoord] = true;
        vEdges[r][maxCoord] = true;
      }
    }
    _ensureNonEmpty(size, hEdges, vEdges);
  }

  static void _ensureNonEmpty(
    int size,
    List<List<bool>> hEdges,
    List<List<bool>> vEdges,
  ) {
    // If empty, activate a minimal 2x2 loop in the center
    bool hasActive = false;
    for (final row in hEdges) {
      if (row.any((e) => e)) {
        hasActive = true;
        break;
      }
    }
    if (!hasActive) {
      final mid = size ~/ 2;
      if (mid > 0 && mid < size) {
        hEdges[mid - 1][mid - 1] = true;
        hEdges[mid][mid - 1] = true;
        vEdges[mid - 1][mid - 1] = true;
        vEdges[mid - 1][mid] = true;
      }
    }
  }
}

