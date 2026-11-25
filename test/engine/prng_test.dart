import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/prng/xoshiro128.dart';

void main() {
  test('independent unsigned 32-bit reference seed vectors', () {
    const vectors = <int, List<int>>{
      0: [4226848253, 3853465007, 1657604656, 2135928087, 1643513283],
      1: [3187778163, 3899520863, 270678034, 2950105546, 3415064141],
      4294967295: [2846478547, 2130249462, 456585916, 4065942502, 3472031905],
    };
    for (final entry in vectors.entries) {
      final random = Xoshiro128(entry.key);
      expect(List.generate(5, (_) => random.nextInt()), entry.value);
    }
    expect(() => Xoshiro128(1).nextBoundedInt(0), throwsArgumentError);
    expect(() => Xoshiro128(1).nextBoundedInt(-1), throwsArgumentError);
  });

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
