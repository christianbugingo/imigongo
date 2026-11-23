// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:imigongo_pattern_puzzle/engine/generator/puzzle_generator.dart';
import 'package:imigongo_pattern_puzzle/engine/solver/puzzle_solver.dart';

/// Offline content generation script.
///
/// Demonstrates procedural generation, time-boxed solver verification, and Par fallback.
/// Runs outside the application UI thread.
void main(List<String> args) {
  // Test generating puzzles for each dimension from 3x3 to 7x7
  final sizes = <int>[3, 4, 5, 6, 7];
  const baseSeed = 20261123;

  print('=== Imigongo Offline Puzzle Generator Tool ===');
  print('Generator Version: ${PuzzleGenerator.generatorVersion}');

  final results = <Map<String, dynamic>>[];

  for (final size in sizes) {
    final seed = baseSeed + size;
    final board = PuzzleGenerator.generate(size: size, seed: seed);

    final solverResult = PuzzleSolver.solve(board: board, timeboxMs: 50);

    print('\nGrid: ${size}x$size | Seed: $seed | Par: ${board.par}');
    print('Solver Status: ${solverResult.status.name} | Time: ${solverResult.elapsedMs}ms');
    print('Target Moves: ${solverResult.targetMoves} (Optimal: ${solverResult.isProvablyOptimal})');

    results.add(<String, dynamic>{
      'size': size,
      'seed': seed,
      'par': board.par,
      'status': solverResult.status.name,
      'optimal': solverResult.isProvablyOptimal,
      'elapsedMs': solverResult.elapsedMs,
      'board': board.toJson(),
    });
  }

  print('\n=== Generation & Verification Summary ===');
  print('Generated ${results.length} verified puzzle levels.');
  print(jsonEncode(<String, dynamic>{'totalLevels': results.length, 'version': PuzzleGenerator.generatorVersion}));
}
