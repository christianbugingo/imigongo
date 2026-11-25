import 'board.dart';

/// Move history belongs to the engine; presentation decides how to animate it.
enum SessionOutcome { playing, won, lost }

class GameSession {
  final Board initialBoard;
  final int? moveLimit;
  Board _board;
  final List<Board> _history = [];
  GameSession(this.initialBoard, {this.moveLimit}) : _board = initialBoard {
    if (moveLimit != null && moveLimit! <= 0) {
      throw ArgumentError.value(moveLimit, 'moveLimit');
    }
  }
  int? get remainingMoves => moveLimit == null
      ? null
      : (moveLimit! - _board.movesTaken).clamp(0, moveLimit!);
  // Success wins the tie when the final permitted turn completes the board.
  SessionOutcome get outcome => _board.isSolved
      ? SessionOutcome.won
      : remainingMoves == 0
      ? SessionOutcome.lost
      : SessionOutcome.playing;
  Board get board => _board;
  bool get canUndo => _history.isNotEmpty;
  void rotateTile(int row, int col) {
    if (moveLimit != null && outcome != SessionOutcome.playing) return;
    final next = _board.rotateTile(row, col);
    _history.add(_board);
    _board = next;
  }

  void undo() {
    if (moveLimit != null && outcome != SessionOutcome.playing) return;
    if (canUndo) _board = _history.removeLast();
  }

  void reset() {
    _history.clear();
    _board = initialBoard;
  }
}
