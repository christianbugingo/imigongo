import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/models/puzzle_enums.dart';

void main() {
  group('GridDimension Tests', () {
    test('Calculates total tiles correctly', () {
      expect(GridDimension.threeByThree.totalTiles, equals(9));
      expect(GridDimension.fourByFour.totalTiles, equals(16));
      expect(GridDimension.fiveByFive.totalTiles, equals(25));
      expect(GridDimension.sevenBySeven.totalTiles, equals(49));
    });

    test('fromSize resolves or defaults gracefully', () {
      expect(GridDimension.fromSize(3), equals(GridDimension.threeByThree));
      expect(GridDimension.fromSize(7), equals(GridDimension.sevenBySeven));
      expect(GridDimension.fromSize(99), equals(GridDimension.threeByThree));
    });
  });

  group('TileRotation Tests', () {
    test('Calculates degrees correctly', () {
      expect(TileRotation.rot0.degrees, equals(0));
      expect(TileRotation.rot90.degrees, equals(90));
      expect(TileRotation.rot180.degrees, equals(180));
      expect(TileRotation.rot270.degrees, equals(270));
    });

    test('Rotates clockwise cyclically', () {
      expect(TileRotation.rot0.rotateClockwise(), equals(TileRotation.rot90));
      expect(TileRotation.rot90.rotateClockwise(), equals(TileRotation.rot180));
      expect(TileRotation.rot180.rotateClockwise(), equals(TileRotation.rot270));
      expect(TileRotation.rot270.rotateClockwise(), equals(TileRotation.rot0));
    });

    test('Rotates counter-clockwise cyclically', () {
      expect(TileRotation.rot0.rotateCounterClockwise(), equals(TileRotation.rot270));
      expect(TileRotation.rot270.rotateCounterClockwise(), equals(TileRotation.rot180));
      expect(TileRotation.rot180.rotateCounterClockwise(), equals(TileRotation.rot90));
      expect(TileRotation.rot90.rotateCounterClockwise(), equals(TileRotation.rot0));
    });

    test('fromQuarterTurns handles negatives and overflows', () {
      expect(TileRotation.fromQuarterTurns(0), equals(TileRotation.rot0));
      expect(TileRotation.fromQuarterTurns(4), equals(TileRotation.rot0));
      expect(TileRotation.fromQuarterTurns(5), equals(TileRotation.rot90));
      expect(TileRotation.fromQuarterTurns(-1), equals(TileRotation.rot270));
    });
  });

  group('StarRating Calculation Tests', () {
    test('Awards 3 stars when moves <= par', () {
      expect(StarRating.calculate(movesTaken: 8, par: 10), equals(StarRating.three));
      expect(StarRating.calculate(movesTaken: 10, par: 10), equals(StarRating.three));
    });

    test('Awards 2 stars when par < moves <= floor(par * 1.5)', () {
      // For par = 10, 2-star threshold is floor(15) = 15
      expect(StarRating.calculate(movesTaken: 11, par: 10), equals(StarRating.two));
      expect(StarRating.calculate(movesTaken: 15, par: 10), equals(StarRating.two));
    });

    test('Awards 1 star when moves exceed 2-star threshold', () {
      expect(StarRating.calculate(movesTaken: 16, par: 10), equals(StarRating.one));
      expect(StarRating.calculate(movesTaken: 50, par: 10), equals(StarRating.one));
    });

    test('Returns 0 stars on invalid inputs', () {
      expect(StarRating.calculate(movesTaken: 0, par: 10), equals(StarRating.zero));
      expect(StarRating.calculate(movesTaken: 5, par: 0), equals(StarRating.zero));
    });
  });
}
