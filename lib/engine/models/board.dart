import '../validator/puzzle_validator.dart';
import 'tile.dart';

/// Represents a square puzzle grid containing [size] x [size] tiles.
class Board {
  final int size;
  final List<Tile> tiles;
  final int seed;
  final int generatorVersion;
  final int par;
  final int movesTaken;

  const Board({
    required this.size,
    required this.tiles,
    required this.seed,
    required this.generatorVersion,
    required this.par,
    this.movesTaken = 0,
  });

  /// Total count of tiles in the grid.
  int get totalTiles => size * size;

  /// Retrieves the tile at the specified row and column.
  Tile tileAt(int row, int col) {
    assert(row >= 0 && row < size, 'Row $row out of bounds [0, $size)');
    assert(col >= 0 && col < size, 'Col $col out of bounds [0, $size)');
    return tiles[row * size + col];
  }

  /// Rotates the tile at [row], [col] clockwise by 1 tap (+90 degrees).
  ///
  /// Controls are clockwise only. Increments [movesTaken] by 1.
  Board rotateTile(int row, int col) {
    final index = row * size + col;
    final updatedTiles = List<Tile>.of(tiles);
    updatedTiles[index] = updatedTiles[index].rotateClockwise();

    return copyWith(
      tiles: updatedTiles,
      movesTaken: movesTaken + 1,
    );
  }

  /// Checks if the board satisfies all geometric continuity rules.
  /// Validated purely by rules, never by comparing against target state.
  bool get isSolved => PuzzleValidator.isSolved(this);

  /// Computes the sum of clockwise taps required to restore every tile to its target orientation.
  int get remainingClockwiseTapsToTarget {
    int total = 0;
    for (final tile in tiles) {
      total += tile.clockwiseDistanceToTarget;
    }
    return total;
  }

  /// Creates a copy of this board with optional modifications.
  Board copyWith({
    int? size,
    List<Tile>? tiles,
    int? seed,
    int? generatorVersion,
    int? par,
    int? movesTaken,
  }) {
    return Board(
      size: size ?? this.size,
      tiles: tiles ?? this.tiles,
      seed: seed ?? this.seed,
      generatorVersion: generatorVersion ?? this.generatorVersion,
      par: par ?? this.par,
      movesTaken: movesTaken ?? this.movesTaken,
    );
  }

  /// Serializes board state to a simple Map.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'size': size,
      'seed': seed,
      'generatorVersion': generatorVersion,
      'par': par,
      'movesTaken': movesTaken,
      'tiles': tiles.map((t) => <String, dynamic>{
        'id': t.tileId,
        'r': t.row,
        'c': t.col,
        'base': t.baseMask,
        'rot': t.currentRotation.quarterTurns,
        'target': t.targetRotation.quarterTurns,
      }).toList(),
    };
  }
}

