// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

import 'package:imigongo_pattern_puzzle/engine/generator/puzzle_generator.dart';

import 'solver/puzzle_solver.dart';

/// Reproducible content-tool sample, never imported by lib/.
void main() {
  const samples = 200;
  final rows = <Map<String, Object>>[];
  final records = <Map<String, Object>>[];
  for (var size = 3; size <= 7; size++) {
    var exact = 0, equal = 0, gapTotal = 0, fallback = 0;
    var microsTotal = 0, maxMicros = 0;
    for (var seed = 0; seed < samples; seed++) {
      final board = PuzzleGenerator.generate(size: size, seed: seed);
      final watch = Stopwatch()..start();
      final result = PuzzleSolver.solve(board: board);
      watch.stop();
      final micros = watch.elapsedMicroseconds;
      microsTotal += micros;
      if (micros > maxMicros) maxMicros = micros;
      if (result.isProvablyOptimal) {
        exact++;
        final gap = board.par - result.targetMoves;
        if (gap < 0) throw StateError('Minimum exceeds verified Par');
        gapTotal += gap;
        if (gap == 0) equal++;
      } else {
        fallback++;
      }
      records.add({
        'size': size,
        'seed': seed,
        'generatorVersion': board.generatorVersion,
        'par': board.par,
        'targetMoves': result.targetMoves,
        'exact': result.isProvablyOptimal,
        'status': result.status.name,
        'elapsedUs': micros,
        'nodes': result.nodesEvaluated,
      });
    }
    rows.add({
      'size': size,
      'samples': samples,
      'exact': exact,
      'parEqualsExact': equal,
      'averageGapAmongExact': exact == 0 ? 'unknown' : gapTotal / exact,
      'fallbacks': fallback,
      'meanSolverMs': microsTotal / samples / 1000,
      'maxSolverMs': maxMicros / 1000,
    });
  }
  print(
    const JsonEncoder.withIndent('  ').convert({
      'generatorVersion': PuzzleGenerator.generatorVersion,
      'seedRange': '0..199 inclusive per size',
      'budgetMs': 50,
      'runtime': Platform.version,
      'os': Platform.operatingSystem,
      'method': 'Sequential cold-to-warm JIT sample; no warmup. External Stopwatch includes solver setup and validation, excludes puzzle generation. Gaps only for proven exact results; fallback minimum unknown.',
      'summary': rows,
      'records': records,
    }),
  );
}
