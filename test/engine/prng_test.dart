import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/prng/xoshiro128.dart';

void main() {
  group('Xoshiro128 PRNG Tests (Documented Test Vectors)', () {
    test('Matches documented fixed test vectors for seed 123456789', () {
      final prng = Xoshiro128(Xoshiro128.testSeed);
      final generated = <int>[];

      for (int i = 0; i < Xoshiro128.expectedTestVectors.length; i++) {
        generated.add(prng.nextInt());
      }

      expect(generated, equals(Xoshiro128.expectedTestVectors));
    });

    test('Identical seeds produce identical sequences', () {
      final prngA = Xoshiro128(987654321);
      final prngB = Xoshiro128(987654321);

      for (int i = 0; i < 50; i++) {
        expect(prngA.nextInt(), equals(prngB.nextInt()));
      }
    });

    test('Different seeds produce different sequences', () {
      final prngA = Xoshiro128(1111);
      final prngB = Xoshiro128(2222);

      final sequenceA = List.generate(10, (_) => prngA.nextInt());
      final sequenceB = List.generate(10, (_) => prngB.nextInt());

      expect(sequenceA, isNot(equals(sequenceB)));
    });

    test('nextBoundedInt produces integers strictly in [0, max - 1]', () {
      final prng = Xoshiro128(42);
      for (int i = 0; i < 200; i++) {
        final val = prng.nextBoundedInt(7);
        expect(val, greaterThanOrEqualTo(0));
        expect(val, lessThan(7));
      }
    });

    test('nextDouble produces values strictly in [0.0, 1.0)', () {
      final prng = Xoshiro128(42);
      for (int i = 0; i < 200; i++) {
        final val = prng.nextDouble();
        expect(val, greaterThanOrEqualTo(0.0));
        expect(val, lessThan(1.0));
      }
    });

    test('generatorVersion is 1', () {
      expect(Xoshiro128.generatorVersion, equals(1));
    });
  });
}
