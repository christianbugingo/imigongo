import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/content/tutorial_boards.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';
import 'package:imigongo_pattern_puzzle/main.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/onboarding_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/puzzle_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/routing/app_router.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/welcome_screen.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/home_screen.dart';

import '../support/tutorial_preferences.dart';

void main() {
  testWidgets('first launch can skip; returning launch goes straight to Home', (
    tester,
  ) async {
    final store = MemoryTutorialPreferences();
    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tutorialPreferencesProvider.overrideWithValue(store)],
        child: const ImigongoPuzzleApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('skip')));
    await tester.pumpAndSettle();
    expect(store.finished, isTrue);
    expect(find.byType(HomeScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tutorialPreferencesProvider.overrideWithValue(store)],
        child: const ImigongoPuzzleApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'three authored lessons lead Home and never change Free Play bests',
    (tester) async {
      final store = MemoryTutorialPreferences();
      final container = ProviderContainer(
        overrides: [tutorialPreferencesProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);
      appRouter.go('/');
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const ImigongoPuzzleApp(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('learn')));
      await tester.pumpAndSettle();
      for (var lesson = 0; lesson < 3; lesson++) {
        expect(find.text('Tutorial ${lesson + 1} of 3'), findsOneWidget);
        final board = TutorialBoards.lesson(lesson);
        for (final tile in board.tiles) {
          for (var tap = 0; tap < tile.clockwiseDistanceToTarget; tap++) {
            await tester.tap(
              find.byKey(ValueKey('tile_${tile.row}_${tile.col}')),
            );
            await tester.pump();
          }
        }
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();
        expect(find.text('Lesson complete'), findsOneWidget);
        expect(find.text('New best'), findsNothing);
        await tester.tap(find.byKey(const ValueKey('result_next')));
        await tester.pumpAndSettle();
        expect(
          container.read(memoryBestsProvider).movesFor(3, lesson, 0),
          isNull,
        );
      }
      expect(store.finished, isTrue);
      expect(find.byType(HomeScreen), findsOneWidget);
      appRouter.go('/');
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('Next puzzle uses next seed at same size', (tester) async {
    appRouter.go('/puzzle?size=3&seed=40');
    // Reuse the one-turn authored board for both keys while keeping real navigation.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tutorialPreferencesProvider.overrideWithValue(
            MemoryTutorialPreferences(finished: true),
          ),
          puzzleBoardFactoryProvider.overrideWithValue(
            (_, _) => TutorialBoards.lesson(0),
          ),
        ],
        child: const ImigongoPuzzleApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tile_0_0')));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('result_next')));
    await tester.pumpAndSettle();
    expect(
      appRouter.routeInformationProvider.value.uri.queryParameters['seed'],
      '41',
    );
    expect(
      appRouter.routeInformationProvider.value.uri.queryParameters['size'],
      '3',
    );
    expect(find.text('Moves: 0'), findsOneWidget);
    appRouter.go('/');
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('welcome reports preference failures with working retry', (
    tester,
  ) async {
    final store = MemoryTutorialPreferences()..failReads = true;
    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [tutorialPreferencesProvider.overrideWithValue(store)],
        child: const ImigongoPuzzleApp(),
      ),
    );
    // Disable Riverpod retry for this test by finishing before the automatic retry delay.
    await tester.pump();
    await tester.pump();
    expect(find.text('Could not load tutorial preferences.'), findsOneWidget);
    store.failReads = false;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    store.failWrites = true;
    await tester.tap(find.byKey(const ValueKey('skip')));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not remember tutorial completion. Please try again.'),
      findsOneWidget,
    );
    expect(store.finished, isFalse);
    await tester.pumpWidget(const SizedBox());
  });

  test('tile semantic label translation is available in French', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('fr'));
    expect(l10n.tileLabel(1, 2, l10n.north), contains('ligne 1'));
  });
}
