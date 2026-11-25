import '../models/board.dart';
import '../models/connection_mask.dart';
import '../models/tile.dart';
import '../prng/xoshiro128.dart';

/// Version 2: a connected frame plus reflected edge orbits from one quadrant.
class PuzzleGenerator {
  static const int generatorVersion = 2;
  PuzzleGenerator._();

  static Board generate({
    required int size,
    required int seed,
    int? targetScrambleTaps,
  }) {
    if (size < 3 || size > 7) throw ArgumentError.value(size, 'size');
    final budget = targetScrambleTaps ?? (size * 2 + 4);
    if (budget < 0) throw ArgumentError.value(budget, 'targetScrambleTaps');
    final random = Xoshiro128(seed);
    final masks = List<int>.filled(size * size, 0);
    void edge(int a, int b) {
      final bit = b == a + 1 ? ConnectionMask.east : ConnectionMask.south;
      masks[a] |= bit;
      masks[b] |= ConnectionMask.rotateClockwise(bit, 2);
    }

    void reflectedEdge(int a, int b) {
      for (var vertical = 0; vertical < 2; vertical++) {
        for (var horizontal = 0; horizontal < 2; horizontal++) {
          int reflect(int i) {
            final r = i ~/ size;
            final c = i % size;
            return (vertical == 0 ? r : size - 1 - r) * size +
                (horizontal == 0 ? c : size - 1 - c);
          }

          final x = reflect(a), y = reflect(b);
          edge(x < y ? x : y, x < y ? y : x);
        }
      }
    }

    // The perimeter guarantees a connected, nonempty starting network.
    for (var i = 0; i < size - 1; i++) {
      edge(i, i + 1);
      edge((size - 1) * size + i, (size - 1) * size + i + 1);
      edge(i * size, (i + 1) * size);
      edge(i * size + size - 1, (i + 1) * size + size - 1);
    }
    // Grow only from the existing network; reflected additions preserve both axes.
    for (var pass = 0; pass < size; pass++) {
      for (var r = 0; r <= (size - 1) ~/ 2; r++) {
        for (var c = 0; c <= (size - 1) ~/ 2; c++) {
          final a = r * size + c;
          for (final b in [
            if (c + 1 < size) a + 1,
            if (r + 1 < size) a + size,
          ]) {
            if ((masks[a] != 0 || masks[b] != 0) &&
                random.nextBoundedInt(3) == 0) {
              reflectedEdge(a, b);
            }
          }
        }
      }
    }
    final tiles = List<Tile>.generate(
      size * size,
      (i) => Tile(tileId: i, row: i ~/ size, col: i % size, baseMask: masks[i]),
    );
    final rotatable = [
      for (var i = 0; i < tiles.length; i++)
        if (ConnectionMask.rotateClockwise(masks[i], 1) != masks[i]) i,
    ];
    for (var tap = 0; tap < budget; tap++) {
      final i = rotatable[random.nextBoundedInt(rotatable.length)];
      tiles[i] = tiles[i].rotateClockwise();
    }
    Board build() => Board(
      size: size,
      tiles: tiles,
      seed: seed,
      generatorVersion: generatorVersion,
      par: tiles.fold(0, (sum, tile) => sum + tile.clockwiseDistanceToTarget),
    );
    if (build().isSolved) {
      final i = rotatable.first;
      tiles[i] = tiles[i].rotateClockwise();
    }
    return build();
  }
}
