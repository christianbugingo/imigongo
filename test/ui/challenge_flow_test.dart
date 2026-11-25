import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/main.dart';
import 'package:imigongo_pattern_puzzle/ui/models/puzzle_view.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/puzzle_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/onboarding_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/routing/app_router.dart';

import '../support/tutorial_preferences.dart';

import 'package:imigongo_pattern_puzzle/engine/content/tutorial_boards.dart';

void main() {
  ProviderContainer setup() => ProviderContainer(
    overrides: [
      tutorialPreferencesProvider.overrideWithValue(
        MemoryTutorialPreferences(finished: true),
      ),
      challengeBoardFactoryProvider.overrideWithValue(
        (level) =>
            TutorialBoards.lesson(0)
                .copyWith(seed: level.seed, generatorVersion: 2),
      ),
    ],
  );
  test(
    'controller freezes failure, refunds Undo and awards once across replay',
    () {
      final container = setup();
      addTearDown(container.dispose);
      final provider = challengePuzzleProvider('easy-1');
      container.listen(provider, (_, _) {});
      final controller = container.read(provider.notifier);
      final start = container.read(provider);
      expect(start.remainingMoves, 7);
      expect(start.previewTiles.first.mask, 6); // valid completed reference
      controller.rotateTile(0, 1);
      expect(container.read(provider).remainingMoves, 6);
      controller.undo();
      expect(container.read(provider).remainingMoves, 7);
      for (var i = 0; i < 7; i++) {
        controller.rotateTile(0, 1);
      }
      expect(container.read(provider).phase, PlayPhase.gameOver);
      expect(container.read(provider).completion, isNull);
      controller.rotateTile(0, 0);
      expect(container.read(provider).movesTaken, 7);
      controller.reset();
      controller.rotateTile(0, 0);
      expect(container.read(provider).completion!.bonusAwarded, 4);
      expect(container.read(patternViewProvider('easy-2'))!.bonusMoves, 4);
      controller.reset();
      controller.rotateTile(0, 0);
      expect(container.read(provider).completion!.bonusAwarded, 0);
      expect(container.read(patternViewProvider('easy-2'))!.bonusMoves, 4);
    },
  );

  testWidgets(
    'difficulty → choose pattern → preview → play → rewarded next preview',
    (tester) async {
      final container = setup();
      addTearDown(container.dispose);
      appRouter.go('/');
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const ImigongoPuzzleApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('difficulty_easy')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('choose_easy-1')));
      await tester.pumpAndSettle();
      expect(
        find.text('Study the completed pattern before you start.'),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('tile_0_0')), findsNothing);
      await tester.tap(find.byKey(const ValueKey('start_challenge')));
      await tester.pumpAndSettle();
      expect(find.text('Moves left: 7'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('reference_thumbnail')));
      await tester.pumpAndSettle();
      expect(find.text('Completed reference pattern'), findsOneWidget);
      await tester.ensureVisible(find.text('Back'));
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('tile_0_0')));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('+4 moves earned for the next pattern'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const ValueKey('result_next')));
      await tester.tap(find.byKey(const ValueKey('result_next')));
      await tester.pumpAndSettle();
      expect(find.text('Pattern 2'), findsOneWidget);
      expect(find.text('Move allowance: 11'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('start_challenge')));
      await tester.pumpAndSettle();
      expect(find.text('Moves left: 11'), findsOneWidget);
      appRouter.go('/');
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('Game over offers Replay with full allowance and no bonus', (
    tester,
  ) async {
    final container = setup();
    addTearDown(container.dispose);
    appRouter.go('/challenge/easy-1');
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ImigongoPuzzleApp(),
      ),
    );
    await tester.pumpAndSettle();
    for (var i = 0; i < 7; i++) {
      await tester.tap(find.byKey(const ValueKey('tile_0_1')));
      await tester.pump();
    }
    await tester.pumpAndSettle();
    expect(find.text('Game over'), findsOneWidget);
    expect(find.byKey(const ValueKey('result_title')), findsNothing);
    expect(container.read(patternViewProvider('easy-2'))!.bonusMoves, 0);
    await tester.tap(find.byKey(const ValueKey('game_over_replay')));
    await tester.pumpAndSettle();
    expect(find.text('Moves left: 7'), findsOneWidget);
    appRouter.go('/');
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  });
}
