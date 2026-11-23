import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/models/puzzle_enums.dart';

void main() {
  group('GridDimension Tests', () {
    test('Calculates total tiles correctly from 3x3 through 7x7', () {
      expect(GridDimension.threeByThree.totalTiles, equals(9));
      expect(GridDimension.fourByFour.totalTiles, equals(16));
      expect(GridDimension.fiveByFive.totalTiles, equals(25));
      expect(GridDimension.sixBySix.totalTiles, equals(36));
      expect(GridDimension.sevenBySeven.totalTiles, equals(49));
    });

    test('fromSize resolves correctly for all supported dimensions', () {
      expect(GridDimension.fromSize(3), equals(GridDimension.threeByThree));
      expect(GridDimension.fromSize(4), equals(GridDimension.fourByFour));
      expect(GridDimension.fromSize(5), equals(GridDimension.fiveByFive));
      expect(GridDimension.fromSize(6), equals(GridDimension.sixBySix));
      expect(GridDimension.fromSize(7), equals(GridDimension.sevenBySeven));
      expect(GridDimension.fromSize(99), equals(GridDimension.threeByThree));
    });
  });

  group('TileRotation Tests (Clockwise Controls)', () {
    test('Calculates quarter turns and degrees', () {
      expect(TileRotation.rot0.quarterTurns, equals(0));
      expect(TileRotation.rot0.degrees, equals(0));
      expect(TileRotation.rot90.quarterTurns, equals(1));
      expect(TileRotation.rot90.degrees, equals(90));
      expect(TileRotation.rot180.quarterTurns, equals(2));
      expect(TileRotation.rot180.degrees, equals(180));
      expect(TileRotation.rot270.quarterTurns, equals(3));
      expect(TileRotation.rot270.degrees, equals(270));
    });

    test('Rotates clockwise cyclically on tap (controls are clockwise-only)', () {
      var rot = TileRotation.rot0;
      rot = rot.rotateClockwise();
      expect(rot, equals(TileRotation.rot90));
      rot = rot.rotateClockwise();
      expect(rot, equals(TileRotation.rot180));
      rot = rot.rotateClockwise();
      expect(rot, equals(TileRotation.rot270));
      rot = rot.rotateClockwise();
      expect(rot, equals(TileRotation.rot0));
    });

    test('fromQuarterTurns normalizes correctly', () {
      expect(TileRotation.fromQuarterTurns(0), equals(TileRotation.rot0));
      expect(TileRotation.fromQuarterTurns(4), equals(TileRotation.rot0));
      expect(TileRotation.fromQuarterTurns(5), equals(TileRotation.rot90));
      expect(TileRotation.fromQuarterTurns(-1), equals(TileRotation.rot270));
    });
  });

  group('StarRating Calculation & Small Par Edge Cases', () {
    test('Par = 0 edge case: returns zero stars (invalid puzzle)', () {
      expect(StarRating.calculate(movesTaken: 0, par: 0), equals(StarRating.zero));
      expect(StarRating.calculate(movesTaken: 1, par: 0), equals(StarRating.zero));
    });

    test('Par = 1 edge case: floor(1 * 1.5) == 1, so 2 stars is unattainable', () {
      // With par = 1:
      // - 1 move is <= par -> 3 stars.
      // - 2 moves: floor(1 * 1.5) = 1, movesTaken (2) > 1, so drops to 1 star.
      // 2 stars cannot occur because there is no integer between par (1) and floor(par * 1.5) (1).
      expect(StarRating.calculate(movesTaken: 1, par: 1), equals(StarRating.three));
      expect(StarRating.calculate(movesTaken: 2, par: 1), equals(StarRating.one));
      expect(StarRating.calculate(movesTaken: 3, par: 1), equals(StarRating.one));
    });

    test('Par = 2 edge case: floor(2 * 1.5) = 3 allows exactly 1 step for 2 stars', () {
      // With par = 2:
      // <= 2 moves -> 3 stars
      // 3 moves -> 2 stars
      // >= 4 moves -> 1 star
      expect(StarRating.calculate(movesTaken: 1, par: 2), equals(StarRating.three));
      expect(StarRating.calculate(movesTaken: 2, par: 2), equals(StarRating.three));
      expect(StarRating.calculate(movesTaken: 3, par: 2), equals(StarRating.two));
      expect(StarRating.calculate(movesTaken: 4, par: 2), equals(StarRating.one));
    });

    test('Par = 3 edge case: floor(3 * 1.5) = 4 allows 4 moves for 2 stars', () {
      // With par = 3:
      // <= 3 moves -> 3 stars
      // 4 moves -> 2 stars
      // >= 5 moves -> 1 star
      expect(StarRating.calculate(movesTaken: 3, par: 3), equals(StarRating.three));
      expect(StarRating.calculate(movesTaken: 4, par: 3), equals(StarRating.two));
      expect(StarRating.calculate(movesTaken: 5, par: 3), equals(StarRating.one));
    });

    test('Standard scale: Par = 10 with clear 3-star, 2-star, and 1-star ranges', () {
      // floor(10 * 1.5) = 15
      expect(StarRating.calculate(movesTaken: 8, par: 10), equals(StarRating.three));
      expect(StarRating.calculate(movesTaken: 10, par: 10), equals(StarRating.three));
      expect(StarRating.calculate(movesTaken: 11, par: 10), equals(StarRating.two));
      expect(StarRating.calculate(movesTaken: 15, par: 10), equals(StarRating.two));
      expect(StarRating.calculate(movesTaken: 16, par: 10), equals(StarRating.one));
    });
  });
}
