import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/content/challenge_catalog.dart';
import 'package:imigongo_pattern_puzzle/engine/generator/center_network_generator.dart';
import 'package:imigongo_pattern_puzzle/engine/models/challenge_progress.dart';
import 'package:imigongo_pattern_puzzle/engine/models/connection_mask.dart';
import 'package:imigongo_pattern_puzzle/engine/models/game_session.dart';
import 'package:imigongo_pattern_puzzle/engine/prng/xoshiro128.dart';

import '../../tool/build_50_levels.dart' show buildCatalog, topologyKey;

void main() {
  test('exact tier ranges, contiguous chains and deterministic content-tool output', () {
    const levels = ChallengeCatalog.levels;
    expect(levels.map((l) => l.number), List.generate(50, (i) => i + 1));
    expect(levels.where((l) => l.tier == ChallengeTier.easy).length, 15);
    expect(levels.where((l) => l.tier == ChallengeTier.medium).length, 20);
    expect(levels.where((l) => l.tier == ChallengeTier.hard).length, 15);
    final rebuilt = buildCatalog();
    for (var i = 0; i < levels.length; i++) {
      final l = levels[i], r = rebuilt[i];
      expect(
        (
          l.id,
          l.number,
          l.size,
          l.seed,
          l.generatorVersion,
          l.paletteId,
          l.nextId,
        ),
        (
          r.id,
          r.number,
          r.size,
          r.seed,
          r.generatorVersion,
          r.paletteId,
          r.nextId,
        ),
      );
      if (l.nextId != null) {
        final next = ChallengeCatalog.find(l.nextId!)!;
        expect(next.number, l.number + 1);
      } else {
        expect(l.number, 50);
      }
      final game = GameSession(
        l.generate(),
        moveLimit: ChallengeRules.baseAllowance(l.generate(), l.tier),
      );
      for (final tile in game.initialBoard.tiles) {
        for (var taps = 0; taps < tile.clockwiseDistanceToTarget; taps++) {
          game.rotateTile(tile.row, tile.col);
        }
      }
      expect(game.outcome, SessionOutcome.won, reason: l.id);
    }
  });

  test('50 unique topology classes even after quarter-turn normalization', () {
    expect(
      ChallengeCatalog.levels
          .map((l) => topologyKey(l.generate()))
          .toSet()
          .length,
      50,
    );
    expect(ChallengeCatalog.levels.map((l) => l.paletteId).toSet().length, 5);
  });

  test('all nine earlier pattern identities still use their v2 seeds', () {
    const seeds = {
      'easy-1': 42,
      'easy-2': 2,
      'easy-3': 71,
      'medium-1': 2,
      'medium-2': 421,
      'medium-3': 119,
      'hard-1': 603,
      'hard-2': 57,
      'hard-3': 808,
    };
    for (final entry in seeds.entries) {
      final l = ChallengeCatalog.find(entry.key)!;
      expect(l.seed, entry.value);
      expect(l.generatorVersion, 2);
    }
  });

  test('v3 fixed vector protects generator identity across future edits', () {
    final board = CenterNetworkGenerator.generate(size: 4, seed: 26000);
    expect(board.par, 19);
    expect(board.tiles.map((t) => t.targetMask), [
      6,
      12,
      6,
      12,
      7,
      15,
      15,
      13,
      7,
      15,
      15,
      13,
      3,
      9,
      3,
      9,
    ]);
    expect(board.tiles.map((t) => t.effectiveMask), [
      3,
      3,
      6,
      9,
      13,
      15,
      15,
      11,
      11,
      15,
      15,
      14,
      3,
      3,
      9,
      6,
    ]);
  });

  test('difficulty boundaries continue the global 1–50 reward chain', () {
    final progress = ChallengeProgress();
    final easyEnd = ChallengeCatalog.find('easy-15')!;
    final mediumEnd = ChallengeCatalog.find('medium-20')!;
    expect(easyEnd.nextId, 'medium-1');
    expect(mediumEnd.nextId, 'hard-1');
    expect(progress.recordWin(easyEnd), 4);
    expect(progress.bonusFor('medium-1'), 4);
    expect(progress.recordWin(mediumEnd), 4);
    expect(progress.bonusFor('hard-1'), 4);
    expect(ChallengeCatalog.find('hard-15')!.nextId, isNull);
  });

  for (var size = 3; size <= 7; size++) {
    test(
      'v3: 1000 seeds ${size}x$size deterministic, symmetric, solvable and Par-correct',
      () {
        final seeds = Xoshiro128(261126 + size);
        for (var trial = 0; trial < 1000; trial++) {
          final seed = seeds.nextInt();
          final board = CenterNetworkGenerator.generate(size: size, seed: seed);
          expect(
            board.toJson(),
            CenterNetworkGenerator.generate(size: size, seed: seed).toJson(),
          );
          expect(board.generatorVersion, 3);
          expect(board.isSolved, isFalse, reason: 'size=$size seed=$seed');
          var restored = board;
          for (final tile in board.tiles) {
            for (var taps = 0; taps < tile.clockwiseDistanceToTarget; taps++) {
              restored = restored.rotateTile(tile.row, tile.col);
            }
          }
          expect(restored.isSolved, isTrue, reason: 'size=$size seed=$seed');
          expect(restored.movesTaken, board.par);
          for (var r = 0; r < size; r++) {
            for (var c = 0; c < size; c++) {
              final m = restored.tileAt(r, c).effectiveMask;
              final horizontal = (m & 5) | ((m & 2) << 2) | ((m & 8) >> 2);
              final vertical = (m & 10) | ((m & 1) << 2) | ((m & 4) >> 2);
              expect(
                restored.tileAt(r, size - 1 - c).effectiveMask,
                horizontal,
              );
              expect(restored.tileAt(size - 1 - r, c).effectiveMask, vertical);
              expect(m & ~ConnectionMask.all, 0);
            }
          }
        }
      },
    );
  }
}
