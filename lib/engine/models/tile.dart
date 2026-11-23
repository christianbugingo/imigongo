import '../../models/puzzle_enums.dart';
import 'connection_mask.dart';

/// Immutable description and state of a single puzzle tile in the grid.
class Tile {
  final int tileId;
  final int row;
  final int col;

  /// 4-bit connection mask at base orientation (TileRotation.rot0).
  final int baseMask;

  /// Current physical rotation on the board.
  final TileRotation currentRotation;

  /// Solved/target rotation of this tile in the generator's solution.
  final TileRotation targetRotation;

  const Tile({
    required this.tileId,
    required this.row,
    required this.col,
    required this.baseMask,
    this.currentRotation = TileRotation.rot0,
    this.targetRotation = TileRotation.rot0,
  });

  /// The active connection mask after applying currentRotation.
  int get effectiveMask => ConnectionMask.rotateClockwise(baseMask, currentRotation.quarterTurns);

  /// The target connection mask in the solved state.
  int get targetMask => ConnectionMask.rotateClockwise(baseMask, targetRotation.quarterTurns);

  /// True if tile matches its target rotation.
  bool get isAtTargetRotation => currentRotation == targetRotation;

  /// Number of clockwise taps needed to reach targetRotation from currentRotation.
  int get clockwiseDistanceToTarget {
    final diff = targetRotation.quarterTurns - currentRotation.quarterTurns;
    return ((diff % 4) + 4) % 4;
  }

  /// Returns a new Tile with rotation advanced by 1 clockwise tap (+90 degrees).
  Tile rotateClockwise() {
    return copyWith(currentRotation: currentRotation.rotateClockwise());
  }

  /// Returns a copy of this tile with specified properties replaced.
  Tile copyWith({
    int? tileId,
    int? row,
    int? col,
    int? baseMask,
    TileRotation? currentRotation,
    TileRotation? targetRotation,
  }) {
    return Tile(
      tileId: tileId ?? this.tileId,
      row: row ?? this.row,
      col: col ?? this.col,
      baseMask: baseMask ?? this.baseMask,
      currentRotation: currentRotation ?? this.currentRotation,
      targetRotation: targetRotation ?? this.targetRotation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tile &&
          runtimeType == other.runtimeType &&
          tileId == other.tileId &&
          row == other.row &&
          col == other.col &&
          baseMask == other.baseMask &&
          currentRotation == other.currentRotation &&
          targetRotation == other.targetRotation;

  @override
  int get hashCode =>
      tileId.hashCode ^
      row.hashCode ^
      col.hashCode ^
      baseMask.hashCode ^
      currentRotation.hashCode ^
      targetRotation.hashCode;
}
