import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/models/connection_mask.dart';

void main() {
  group('ConnectionMask Bitwise Operations', () {
    test('Edge bit values match directional constants', () {
      expect(ConnectionMask.north, equals(1));
      expect(ConnectionMask.east, equals(2));
      expect(ConnectionMask.south, equals(4));
      expect(ConnectionMask.west, equals(8));
      expect(ConnectionMask.all, equals(15));
    });

    test('Helper functions detect directional presence', () {
      const mask = ConnectionMask.north | ConnectionMask.south; // Line NS
      expect(ConnectionMask.hasNorth(mask), isTrue);
      expect(ConnectionMask.hasEast(mask), isFalse);
      expect(ConnectionMask.hasSouth(mask), isTrue);
      expect(ConnectionMask.hasWest(mask), isFalse);
    });

    test('Clockwise rotation of straight line', () {
      const lineNS = ConnectionMask.lineNorthSouth; // N | S (1 | 4 = 5)
      // 1 turn CW: North -> East, South -> West = East | West (2 | 8 = 10)
      final turn1 = ConnectionMask.rotateClockwise(lineNS, 1);
      expect(turn1, equals(ConnectionMask.lineEastWest));

      // 2 turns CW: returns to lineNorthSouth
      final turn2 = ConnectionMask.rotateClockwise(lineNS, 2);
      expect(turn2, equals(ConnectionMask.lineNorthSouth));

      // 4 turns CW: identity
      final turn4 = ConnectionMask.rotateClockwise(lineNS, 4);
      expect(turn4, equals(ConnectionMask.lineNorthSouth));
    });

    test('Clockwise rotation of corner elbow', () {
      const cornerNE = ConnectionMask.cornerNorthEast; // N | E (1 | 2 = 3)
      // 1 turn CW: N -> E, E -> S = East | South (2 | 4 = 6)
      final turn1 = ConnectionMask.rotateClockwise(cornerNE, 1);
      expect(turn1, equals(ConnectionMask.cornerEastSouth));

      // 2 turns CW: E -> S, S -> W = South | West (4 | 8 = 12)
      final turn2 = ConnectionMask.rotateClockwise(cornerNE, 2);
      expect(turn2, equals(ConnectionMask.cornerSouthWest));

      // 3 turns CW: S -> W, W -> N = West | North (8 | 1 = 9)
      final turn3 = ConnectionMask.rotateClockwise(cornerNE, 3);
      expect(turn3, equals(ConnectionMask.cornerWestNorth));

      // 4 turns CW: returns to cornerNE
      final turn4 = ConnectionMask.rotateClockwise(cornerNE, 4);
      expect(turn4, equals(ConnectionMask.cornerNorthEast));
    });

    test('All-cross is invariant under rotation', () {
      const cross = ConnectionMask.crossAll;
      for (int i = 0; i < 4; i++) {
        expect(ConnectionMask.rotateClockwise(cross, i), equals(ConnectionMask.crossAll));
      }
    });
  });
}

