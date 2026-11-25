import '../../models/puzzle_enums.dart';
import '../models/board.dart';
import '../models/connection_mask.dart';
import '../models/tile.dart';
import '../prng/xoshiro128.dart';

/// Version 3 grows reflected edge orbits from a connected central seed.
/// Unlike v2, the perimeter is optional; empty space and branch density vary.
class CenterNetworkGenerator {
  static const generatorVersion = 3;
  static Board generate({required int size, required int seed}) {
    if (size < 3 || size > 7) throw ArgumentError.value(size, 'size');
    final random = Xoshiro128(seed);
    (int, int) ordered(int a, int b) => a < b ? (a, b) : (b, a);
    List<(int, int)> orbit(int a, int b) {
      final edges = <(int, int)>{};
      for (var flipRow = 0; flipRow < 2; flipRow++) {
        for (var flipCol = 0; flipCol < 2; flipCol++) {
          int reflect(int i) =>
              (flipRow == 0 ? i ~/ size : size - 1 - i ~/ size) * size +
              (flipCol == 0 ? i % size : size - 1 - i % size);
          edges.add(ordered(reflect(a), reflect(b)));
        }
      }
      return edges.toList()..sort(
        (a, b) => a.$1 != b.$1 ? a.$1.compareTo(b.$1) : a.$2.compareTo(b.$2),
      );
    }

    final selected = <(int, int)>{};
    final mid = size ~/ 2;
    if (size.isOdd) {
      final center = mid * size + mid;
      final axes = random.nextBoundedInt(3);
      if (axes != 1) selected.addAll(orbit(center, center + 1));
      if (axes != 0) selected.addAll(orbit(center, center + size));
    } else {
      final topLeft = (mid - 1) * size + mid - 1;
      selected.addAll(orbit(topLeft, topLeft + 1));
      selected.addAll(orbit(topLeft, topLeft + size));
    }
    final orbits = <String, List<(int, int)>>{};
    for (var r = 0; r < size; r++) {
      for (var c = 0; c < size; c++) {
        final a = r * size + c;
        for (final b in [if (c + 1 < size) a + 1, if (r + 1 < size) a + size]) {
          final edges = orbit(a, b);
          orbits.putIfAbsent(
            edges.map((e) => '${e.$1}:${e.$2}').join(','),
            () => edges,
          );
        }
      }
    }
    final targetEdges = size + random.nextBoundedInt(size * size + 1);
    while (selected.length < targetEdges) {
      final active = {
        for (final edge in selected) ...[edge.$1, edge.$2],
      };
      // Reflection invariance means every added orbit is anchored to the network.
      final frontier = [
        for (final edges in orbits.values)
          if (!selected.contains(edges.first) &&
              edges.any((e) => active.contains(e.$1) || active.contains(e.$2)))
            edges,
      ];
      if (frontier.isEmpty) break;
      selected.addAll(frontier[random.nextBoundedInt(frontier.length)]);
    }
    final masks = List<int>.filled(size * size, 0);
    for (final edge in selected) {
      final bit = edge.$2 == edge.$1 + 1
          ? ConnectionMask.east
          : ConnectionMask.south;
      masks[edge.$1] |= bit;
      masks[edge.$2] |= ConnectionMask.rotateClockwise(bit, 2);
    }
    final tiles = [
      for (var i = 0; i < masks.length; i++)
        Tile(
          tileId: i,
          row: i ~/ size,
          col: i % size,
          baseMask: masks[i],
          currentRotation: TileRotation.fromQuarterTurns(
            random.nextBoundedInt(4),
          ),
        ),
    ];
    Board board() => Board(
      size: size,
      tiles: tiles,
      seed: seed,
      generatorVersion: generatorVersion,
      par: tiles.fold<int>(
        0,
        (sum, tile) => sum + tile.clockwiseDistanceToTarget,
      ),
    );
    if (board().isSolved) {
      final index = tiles.indexWhere(
        (t) =>
            ConnectionMask.rotateClockwise(t.effectiveMask, 1) !=
            t.effectiveMask,
      );
      tiles[index] = tiles[index].rotateClockwise();
    }
    return board();
  }
}
