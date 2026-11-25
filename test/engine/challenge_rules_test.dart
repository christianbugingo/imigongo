import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/content/challenge_catalog.dart';
import 'package:imigongo_pattern_puzzle/engine/models/challenge_progress.dart';
import 'package:imigongo_pattern_puzzle/engine/models/game_session.dart';
import 'package:imigongo_pattern_puzzle/engine/content/tutorial_boards.dart';

void main() {
  test('solving on final allowed turn wins; unsolved zero loses and locks', () {
    final success = GameSession(TutorialBoards.lesson(0), moveLimit: 1);
    success.rotateTile(0, 0);
    expect(success.remainingMoves, 0);
    expect(success.outcome, SessionOutcome.won);
    final failure = GameSession(TutorialBoards.lesson(0), moveLimit: 1);
    failure.rotateTile(0, 1);
    expect(failure.remainingMoves, 0);
    expect(failure.outcome, SessionOutcome.lost);
    failure.rotateTile(0, 0);
    failure.undo();
    expect(failure.board.movesTaken, 1);
    failure.reset();
    expect(failure.remainingMoves, 1);
    expect(failure.outcome, SessionOutcome.playing);
  });

  test(
    'undo refunds moves, invalid input costs nothing, free play has no cap',
    () {
      final session = GameSession(TutorialBoards.lesson(0), moveLimit: 3);
      session.rotateTile(0, 1);
      expect(session.remainingMoves, 2);
      session.undo();
      expect(session.remainingMoves, 3);
      expect(() => session.rotateTile(0, 3), throwsRangeError);
      expect(session.remainingMoves, 3);
      final unlimited = GameSession(TutorialBoards.lesson(0));
      for (var i = 0; i < 100; i++) {
        unlimited.rotateTile(0, 1);
      }
      expect(unlimited.remainingMoves, isNull);
      expect(unlimited.outcome, SessionOutcome.playing);
      expect(
        () => GameSession(TutorialBoards.lesson(0), moveLimit: 0),
        throwsArgumentError,
      );
    },
  );

  test('+4 goes only to the next pattern, once; replays cannot farm it', () {
    final ledger = ChallengeProgress();
    final first = ChallengeCatalog.find('easy-1')!;
    expect(ledger.recordWin(first), 4);
    expect(ledger.recordWin(first), 0);
    expect(ledger.bonusFor('easy-2'), 4);
    expect(ledger.bonusFor('easy-3'), 0);
    expect(ledger.bonusFor('medium-1'), 0);
    expect(ledger.recordWin(ChallengeCatalog.find('easy-2')!), 4);
    expect(ledger.bonusFor('easy-3'), 4);
    expect(ledger.recordWin(ChallengeCatalog.find('hard-15')!), 0);
  });

  test('50-level catalog has stable identity, valid previews, and solvable allowances', () {
    expect(ChallengeCatalog.levels.length, 50);
    expect(ChallengeCatalog.levels.map((l) => l.id).toSet().length, 50);
    final targets = <String>{};
    for (final level in ChallengeCatalog.levels) {
      final board = level.generate();
      expect(board.generatorVersion, level.generatorVersion);
      final solved = board.copyWith(
        tiles: [
          for (final t in board.tiles)
            t.copyWith(currentRotation: t.targetRotation),
        ],
      );
      expect(solved.isSolved, isTrue);
      targets.add(
        '${board.size}:${board.tiles.map((t) => t.targetMask).join(",")}',
      );
      expect(
        ChallengeRules.baseAllowance(board, level.tier),
        greaterThanOrEqualTo(board.par),
      );
      if (level.nextId != null) {
        expect(ChallengeCatalog.find(level.nextId!), isNotNull);
      }
    }
    expect(targets.length, ChallengeCatalog.levels.length);
    expect(ChallengeCatalog.find('unknown'), isNull);
  });
}
