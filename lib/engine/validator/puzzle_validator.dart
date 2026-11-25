import '../models/board.dart';
import '../models/connection_mask.dart';

/// Detailed result of validating a puzzle board against geometric rules.
class ValidationResult {
  final bool isValid;
  final int brokenEdgesCount;
  final int totalActiveEdges;
  final String? firstDiscontinuityReason;

  const ValidationResult({
    required this.isValid,
    required this.brokenEdgesCount,
    required this.totalActiveEdges,
    this.firstDiscontinuityReason,
  });

  static const ValidationResult valid = ValidationResult(
    isValid: true,
    brokenEdgesCount: 0,
    totalActiveEdges: 0,
  );
}

/// Rule-based validator for geometric Imigongo puzzle boards.
///
/// Validates purely by structural and topological rules (edge continuity and boundary
/// closure and a single connected network), never by comparing against a stored target solution.
class PuzzleValidator {
  PuzzleValidator._();

  /// Validates the board state against topological continuity rules:
  /// 1. Internal Edge Continuity: Adjacent tiles must share matching edge states (both connected or both open).
  /// 2. Outer Boundary Closure: Paths cannot terminate into the empty frame outside the grid.
  /// 3. Non-Triviality: At least one active tile.
  /// 4. Connectivity: All active tiles belong to one network.
  static ValidationResult validate(Board board) {
    int brokenCount = 0;
    int activeEdges = 0;
    String? firstReason;

    final size = board.size;

    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        final tile = board.tileAt(r, c);
        final mask = tile.effectiveMask;

        if (ConnectionMask.hasNorth(mask)) activeEdges++;
        if (ConnectionMask.hasEast(mask)) activeEdges++;
        if (ConnectionMask.hasSouth(mask)) activeEdges++;
        if (ConnectionMask.hasWest(mask)) activeEdges++;

        // Rule 1: Outer Boundary Closure (no open ridges escaping the board)
        if (r == 0 && ConnectionMask.hasNorth(mask)) {
          brokenCount++;
          firstReason ??=
              'Open North connection escaping top boundary at ($r, $c)';
        }
        if (r == size - 1 && ConnectionMask.hasSouth(mask)) {
          brokenCount++;
          firstReason ??=
              'Open South connection escaping bottom boundary at ($r, $c)';
        }
        if (c == 0 && ConnectionMask.hasWest(mask)) {
          brokenCount++;
          firstReason ??=
              'Open West connection escaping left boundary at ($r, $c)';
        }
        if (c == size - 1 && ConnectionMask.hasEast(mask)) {
          brokenCount++;
          firstReason ??=
              'Open East connection escaping right boundary at ($r, $c)';
        }

        // Rule 2: Internal Horizontal Edge Continuity
        if (c < size - 1) {
          final eastNeighbor = board.tileAt(r, c + 1);
          final hasEast = ConnectionMask.hasEast(mask);
          final neighborHasWest = ConnectionMask.hasWest(
            eastNeighbor.effectiveMask,
          );
          if (hasEast != neighborHasWest) {
            brokenCount++;
            firstReason ??=
                'Horizontal edge mismatch between ($r, $c) East and ($r, ${c + 1}) West';
          }
        }

        // Rule 3: Internal Vertical Edge Continuity
        if (r < size - 1) {
          final southNeighbor = board.tileAt(r + 1, c);
          final hasSouth = ConnectionMask.hasSouth(mask);
          final neighborHasNorth = ConnectionMask.hasNorth(
            southNeighbor.effectiveMask,
          );
          if (hasSouth != neighborHasNorth) {
            brokenCount++;
            firstReason ??=
                'Vertical edge mismatch between ($r, $c) South and (${r + 1}, $c) North';
          }
        }
      }
    }

    // Rule 4: Non-triviality (must contain at least one active edge)
    if (activeEdges == 0) {
      return const ValidationResult(
        isValid: false,
        brokenEdgesCount: 0,
        totalActiveEdges: 0,
        firstDiscontinuityReason:
            'Board is trivial: contains no active geometric paths',
      );
    }

    final active = <int>{
      for (var i = 0; i < board.tiles.length; i++)
        if (board.tiles[i].effectiveMask != 0) i,
    };
    final visited = <int>{};
    final pending = <int>[active.first];
    while (pending.isNotEmpty) {
      final index = pending.removeLast();
      if (!visited.add(index)) continue;
      final row = index ~/ size;
      final col = index % size;
      final mask = board.tiles[index].effectiveMask;
      for (var direction = 0; direction < 4; direction++) {
        final nr = row + const [-1, 0, 1, 0][direction];
        final nc = col + const [0, 1, 0, -1][direction];
        if (nr < 0 || nr >= size || nc < 0 || nc >= size) continue;
        final next = nr * size + nc;
        if ((mask & (1 << direction)) != 0 &&
            (board.tiles[next].effectiveMask & (1 << ((direction + 2) % 4))) !=
                0) {
          pending.add(next);
        }
      }
    }
    final connected = visited.length == active.length;
    if (!connected) firstReason ??= 'Disconnected active tile networks';
    return ValidationResult(
      isValid: brokenCount == 0 && connected,
      brokenEdgesCount: brokenCount,
      totalActiveEdges: activeEdges,
      firstDiscontinuityReason: firstReason,
    );
  }

  /// Fast boolean check if board is validly solved.
  static bool isSolved(Board board) {
    return validate(board).isValid;
  }
}
