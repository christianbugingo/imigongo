import 'board.dart';

/// Move history belongs to the engine; presentation decides how to animate it.
class GameSession {
  final Board initialBoard;
  Board _board;
  final List<Board> _history = [];
  GameSession(this.initialBoard) : _board = initialBoard;
  Board get board => _board;
  bool get canUndo => _history.isNotEmpty;
  void rotateTile(int row, int col) {
    final next = _board.rotateTile(row, col);
    _history.add(_board);
    _board = next;
  }

  void undo() {
    if (canUndo) _board = _history.removeLast();
  }

  void reset() {
    _history.clear();
    _board = initialBoard;
  }
}
