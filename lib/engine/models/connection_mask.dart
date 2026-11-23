/// Pure bitmask operations representing directional edge connections for puzzle tiles.
///
/// Each edge is mapped to a single bit:
/// - Bit 0 (value 1): North
/// - Bit 1 (value 2): East
/// - Bit 2 (value 4): South
/// - Bit 3 (value 8): West
class ConnectionMask {
  ConnectionMask._();

  static const int none = 0;
  static const int north = 1 << 0; // 1
  static const int east = 1 << 1;  // 2
  static const int south = 1 << 2; // 4
  static const int west = 1 << 3;  // 8

  static const int all = north | east | south | west; // 15

  // Common tile archetypes at base orientation (0 degrees)
  static const int lineNorthSouth = north | south; // 5
  static const int lineEastWest = east | west;     // 10
  static const int cornerNorthEast = north | east; // 3
  static const int cornerEastSouth = east | south; // 6
  static const int cornerSouthWest = south | west; // 12
  static const int cornerWestNorth = west | north; // 9
  static const int tJunctionNoWest = north | east | south; // 7
  static const int crossAll = all; // 15

  static bool hasNorth(int mask) => (mask & north) != 0;
  static bool hasEast(int mask) => (mask & east) != 0;
  static bool hasSouth(int mask) => (mask & south) != 0;
  static bool hasWest(int mask) => (mask & west) != 0;

  /// Rotates a 4-bit connection mask clockwise by [quarterTurns].
  ///
  /// Rotation map: North (0) -> East (1) -> South (2) -> West (3) -> North (0).
  static int rotateClockwise(int mask, int quarterTurns) {
    final turns = ((quarterTurns % 4) + 4) % 4;
    var current = mask & 0x0F;
    for (int i = 0; i < turns; i++) {
      final bitNorth = (current & north) != 0 ? 1 : 0;
      final bitEast = (current & east) != 0 ? 1 : 0;
      final bitSouth = (current & south) != 0 ? 1 : 0;
      final bitWest = (current & west) != 0 ? 1 : 0;

      current = (bitNorth << 1) | // North -> East
                (bitEast << 2) |  // East -> South
                (bitSouth << 3) | // South -> West
                (bitWest << 0);   // West -> North
    }
    return current;
  }
}
