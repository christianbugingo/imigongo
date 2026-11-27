import 'package:imigongo_pattern_puzzle/ui/providers/onboarding_provider.dart';

import '../support/tutorial_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/main.dart';
import 'package:imigongo_pattern_puzzle/ui/routing/app_router.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/home_screen.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/puzzle_screen.dart';

void main() {
  testWidgets('Home opens Settings and Free Play size selection', (
    tester,
  ) async {
    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tutorialPreferencesProvider.overrideWithValue(
            MemoryTutorialPreferences(finished: true),
          ),
        ],
        child: const ImigongoPuzzleApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Sound effects'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
    await tester.tap(find.text('Free Play'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('6×6'));
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();
    expect(find.byType(PuzzleScreen), findsOneWidget);
    expect(find.text('Free Play · 6×6'), findsOneWidget);
    expect(find.text('Moves: 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
    appRouter.go('/');
    await tester.pumpAndSettle();
  });
}
