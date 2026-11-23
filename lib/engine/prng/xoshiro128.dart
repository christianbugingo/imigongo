/// Deterministic 32-bit pseudo-random number generator using Xoshiro128++.
///
/// Xoshiro128++ (Vigna & Blackman) is a fast, high-quality, all-integer PRNG.
/// All state transitions operate strictly on unsigned 32-bit integers (& 0xFFFFFFFF),
/// guaranteeing 100% deterministic, cross-platform results across 32-bit, 64-bit,
/// and web environments.
class Xoshiro128 {
  /// Current PRNG generator version.
  static const int generatorVersion = 1;

  final int initialSeed;
  int _s0;
  int _s1;
  int _s2;
  int _s3;

  /// Initializes the PRNG with a seed.
  /// Uses a SplitMix32 subroutine to expand a single seed into the 4 state words.
  Xoshiro128(this.initialSeed)
      : _s0 = 0,
        _s1 = 0,
        _s2 = 0,
        _s3 = 0 {
    _initFromSeed(initialSeed);
  }

  void _initFromSeed(int seed) {
    int smState = seed & 0xFFFFFFFF;
    int nextSm() {
      smState = (smState + 0x9E3779B9) & 0xFFFFFFFF;
      int z = smState;
      z = ((z ^ (z >> 16)) * 0x85EBCA6B) & 0xFFFFFFFF;
      z = ((z ^ (z >> 13)) * 0xC2B2AE35) & 0xFFFFFFFF;
      return (z ^ (z >> 16)) & 0xFFFFFFFF;
    }

    _s0 = nextSm();
    _s1 = nextSm();
    _s2 = nextSm();
    _s3 = nextSm();

    // Ensure non-zero state
    if ((_s0 | _s1 | _s2 | _s3) == 0) {
      _s0 = 1;
    }
  }

  static int _rotl(int x, int k) {
    return (((x << k) & 0xFFFFFFFF) | ((x & 0xFFFFFFFF) >> (32 - k))) & 0xFFFFFFFF;
  }

  /// Generates the next pseudo-random 32-bit unsigned integer [0, 2^32 - 1].
  int nextInt() {
    final result = (_rotl((_s0 + _s3) & 0xFFFFFFFF, 7) + _s0) & 0xFFFFFFFF;

    final t = (_s1 << 9) & 0xFFFFFFFF;

    _s2 = (_s2 ^ _s0) & 0xFFFFFFFF;
    _s3 = (_s3 ^ _s1) & 0xFFFFFFFF;
    _s1 = (_s1 ^ _s2) & 0xFFFFFFFF;
    _s0 = (_s0 ^ _s3) & 0xFFFFFFFF;

    _s2 = (_s2 ^ t) & 0xFFFFFFFF;
    _s3 = _rotl(_s3, 11);

    return result;
  }

  /// Returns an integer in range [0, max - 1].
  int nextBoundedInt(int max) {
    if (max <= 1) return 0;
    return (nextInt() % max).abs();
  }

  /// Returns a floating-point number in range [0.0, 1.0).
  double nextDouble() {
    return nextInt() / 4294967296.0;
  }

  /// Test vector reference: For seed = 123456789, the first 5 nextInt() outputs
  /// are deterministic constants used for test vector validation.
  static const int testSeed = 123456789;
  static const List<int> expectedTestVectors = <int>[
    3168685543,
    1443940476,
    2581779008,
    4122392184,
    3303506236,
  ];
}
