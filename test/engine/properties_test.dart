import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/generator/puzzle_generator.dart';
import 'package:imigongo_pattern_puzzle/engine/models/board.dart';
import 'package:imigongo_pattern_puzzle/engine/models/connection_mask.dart';
import 'package:imigongo_pattern_puzzle/engine/models/game_session.dart';
import 'package:imigongo_pattern_puzzle/engine/models/tile.dart';
import 'package:imigongo_pattern_puzzle/engine/prng/xoshiro128.dart';
import 'package:imigongo_pattern_puzzle/models/puzzle_enums.dart';

import '../../tool/solver/puzzle_solver.dart';

Board fixture(int size, List<int> masks) => Board(
  size: size,
  tiles: [
    for (var i = 0; i < masks.length; i++)
      Tile(tileId: i, row: i ~/ size, col: i % size, baseMask: masks[i]),
  ],
  seed: 0,
  generatorVersion: 2,
  par: 0,
);

int mirror(int mask, bool horizontal) {
  var result = mask & (horizontal ? 5 : 10);
  if (horizontal) {
    if (mask & 2 != 0) result |= 8;
    if (mask & 8 != 0) result |= 2;
  } else {
    if (mask & 1 != 0) result |= 4;
    if (mask & 4 != 0) result |= 1;
  }
  return result;
}

void main() {
  for (var size = 3; size <= 7; size++) {
    test('1000 seeds: ${size}x$size determinism, solution, Par, symmetry', () {
      final seeds = Xoshiro128(20261125 + size);
      for (var trial = 0; trial < 1000; trial++) {
        final seed = seeds.nextInt();
        final board = PuzzleGenerator.generate(size: size, seed: seed);
        expect(
          board.toJson(),
          PuzzleGenerator.generate(size: size, seed: seed).toJson(),
          reason: 'seed=$seed',
        );
        expect(board.toJson()['generatorVersion'], 2);
        expect(board.isSolved, isFalse, reason: 'seed=$seed');
        var solved = board;
        for (final tile in board.tiles) {
          for (var tap = 0; tap < tile.clockwiseDistanceToTarget; tap++) {
            solved = solved.rotateTile(tile.row, tile.col);
          }
        }
        expect(solved.isSolved, isTrue, reason: 'seed=$seed');
        expect(solved.movesTaken, board.par);
        for (var r = 0; r < size; r++) {
          for (var c = 0; c < size; c++) {
            final m = solved.tileAt(r, c).effectiveMask;
            expect(
              solved.tileAt(r, size - 1 - c).effectiveMask,
              mirror(m, true),
            );
            expect(
              solved.tileAt(size - 1 - r, c).effectiveMask,
              mirror(m, false),
            );
          }
        }
      }
    });
  }

  test('separate closed loops are not one network', () {
    final masks = List<int>.filled(16, 0);
    for (final offset in [0, 10]) {
      masks[offset] = 6;
      masks[offset + 1] = 12;
      masks[offset + 4] = 3;
      masks[offset + 5] = 9;
    }
    expect(fixture(4, masks).isSolved, isFalse);
  });

  test(
    'end, straight, tee and cross participate in a valid connected graph',
    () {
      expect(fixture(3, [6, 14, 12, 7, 15, 13, 3, 11, 9]).isSolved, isTrue);
      expect(fixture(3, [0, 4, 0, 2, 11, 8, 0, 0, 0]).isSolved, isTrue);
      expect(fixture(3, [0, 4, 0, 0, 5, 0, 0, 1, 0]).isSolved, isTrue);
    },
  );

  test(
    'all 16 masks use cheapest visually equivalent clockwise restoration',
    () {
      for (var mask = 0; mask < 16; mask++) {
        for (final rotation in TileRotation.values) {
          final tile = Tile(
            tileId: 0,
            row: 0,
            col: 0,
            baseMask: mask,
            currentRotation: rotation,
          );
          final taps = tile.clockwiseDistanceToTarget;
          expect(
            ConnectionMask.rotateClockwise(tile.effectiveMask, taps),
            mask,
          );
          for (var smaller = 0; smaller < taps; smaller++) {
            expect(
              ConnectionMask.rotateClockwise(tile.effectiveMask, smaller),
              isNot(mask),
            );
          }
        }
      }
      const straight = Tile(
        tileId: 0,
        row: 0,
        col: 0,
        baseMask: 5,
        currentRotation: TileRotation.rot270,
      );
      expect(straight.clockwiseDistanceToTarget, 1);
    },
  );

  test('undo snapshots, reset and invalid coordinates preserve state', () {
    final initial = PuzzleGenerator.generate(size: 3, seed: 123);
    final session = GameSession(initial);
    session.undo();
    session.rotateTile(0, 0);
    final afterOne = session.board;
    session.rotateTile(1, 1);
    session.undo();
    expect(identical(session.board, afterOne), isTrue);
    session.undo();
    expect(identical(session.board, initial), isTrue);
    expect(session.canUndo, isFalse);
    expect(() => session.rotateTile(0, 3), throwsRangeError);
    expect(session.canUndo, isFalse);
    session.rotateTile(0, 0);
    session.reset();
    expect(session.board.movesTaken, 0);
    expect(session.canUndo, isFalse);
    expect(() => initial.tiles.clear(), throwsUnsupportedError);
  });

  test('bad generator parameters fail in release too', () {
    expect(
      () => PuzzleGenerator.generate(size: 2, seed: 0),
      throwsArgumentError,
    );
    expect(
      () => PuzzleGenerator.generate(size: 3, seed: 0, targetScrambleTaps: -1),
      throwsArgumentError,
    );
  });

  test('solver equals independent exhaustive 2x2 orientation oracle', () {
    final solved = fixture(2, [6, 12, 3, 9]);
    for (var scramble = 0; scramble < 256; scramble += 7) {
      final tiles = [
        for (var i = 0; i < 4; i++)
          solved.tiles[i].copyWith(
            currentRotation: TileRotation.fromQuarterTurns(
              (scramble >> (2 * i)) & 3,
            ),
          ),
      ];
      var board = solved.copyWith(tiles: tiles);
      board = board.copyWith(par: board.remainingClockwiseTapsToTarget);
      var minimum = 100;
      for (var assignment = 0; assignment < 256; assignment++) {
        var cost = 0;
        final candidate = <Tile>[];
        for (var i = 0; i < 4; i++) {
          final taps = (assignment >> (2 * i)) & 3;
          cost += taps;
          candidate.add(
            tiles[i].copyWith(
              currentRotation: TileRotation.fromQuarterTurns(
                tiles[i].currentRotation.quarterTurns + taps,
              ),
            ),
          );
        }
        if (cost < minimum && board.copyWith(tiles: candidate).isSolved) {
          minimum = cost;
        }
      }
      final result = PuzzleSolver.solve(board: board);
      expect(result.isProvablyOptimal, isTrue);
      expect(result.targetMoves, minimum);
    }
  });

  test('engine is pure Dart and application cannot import the tool solver', () {
    for (final file in Directory(
      'lib',
    ).listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      final imports = RegExp(r'''(?:import|export)\s+['"]([^'"]+)['"]''')
          .allMatches(file.readAsStringSync());
      for (final match in imports) {
        final uri = match.group(1)!;
        expect(
          uri.contains('puzzle_solver') || uri.contains('/tool/'),
          isFalse,
        );
        if (file.path.startsWith('lib/engine/')) {
          expect(
            uri.startsWith('package:') || uri.startsWith('dart:ui'),
            isFalse,
          );
        }
      }
    }
  });
}
