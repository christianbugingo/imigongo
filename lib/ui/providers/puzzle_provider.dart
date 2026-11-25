import 'package:flutter_riverpod/legacy.dart';
import '../../engine/generator/puzzle_generator.dart';
import '../../engine/models/board.dart';
import '../../models/puzzle_enums.dart';

class PuzzleState {
  final Board board;
  final bool isSolved;
  final StarRating stars;
  final bool hasWon;

  const PuzzleState({
    required this.board,
    required this.isSolved,
    required this.stars,
    required this.hasWon,
  });

  PuzzleState copyWith({
    Board? board,
    bool? isSolved,
    StarRating? stars,
    bool? hasWon,
  }) {
    return PuzzleState(
      board: board ?? this.board,
      isSolved: isSolved ?? this.isSolved,
      stars: stars ?? this.stars,
      hasWon: hasWon ?? this.hasWon,
    );
  }
}

final puzzleProvider = StateNotifierProvider.family<PuzzleNotifier, PuzzleState, (int, int)>(
  (ref, args) {
    final size = args.$1;
    final seed = args.$2;
    return PuzzleNotifier(size: size, seed: seed);
  },
);

class PuzzleNotifier extends StateNotifier<PuzzleState> {
  final int size;
  final int seed;
  late final Board _initialBoard;

  PuzzleNotifier({required this.size, required this.seed})
      : super(
          PuzzleState(
            board: PuzzleGenerator.generate(size: size, seed: seed),
            isSolved: false,
            stars: StarRating.zero,
            hasWon: false,
          ),
        ) {
    _initialBoard = state.board;
  }

  /// Rotates a tile at (row, col) clockwise by 1 tap (+90 degrees).
  void rotateTile(int row, int col) {
    if (state.hasWon) return; // Ignore input once level is already solved

    final updatedBoard = state.board.rotateTile(row, col);
    final solved = updatedBoard.isSolved;
    final stars = solved
        ? StarRating.calculate(movesTaken: updatedBoard.movesTaken, par: updatedBoard.par)
        : StarRating.zero;

    state = state.copyWith(
      board: updatedBoard,
      isSolved: solved,
      stars: stars,
      hasWon: solved,
    );
  }

  /// Resets the current puzzle back to its initial scrambled state.
  void reset() {
    state = PuzzleState(
      board: _initialBoard,
      isSolved: false,
      stars: StarRating.zero,
      hasWon: false,
    );
  }
}

