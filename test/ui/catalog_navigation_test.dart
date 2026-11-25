import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/main.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/onboarding_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/routing/app_router.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/pattern_selection_screen.dart';

import '../support/tutorial_preferences.dart';

void main() {
  testWidgets(
    'lazy Hard list reaches Pattern 50 and opens its colored preview',
    (tester) async {
      appRouter.go('/patterns/hard');
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
      final last = find.byKey(const ValueKey('choose_hard-15'));
      expect(last, findsNothing);
      final list = find
          .descendant(
            of: find.byType(PatternSelectionScreen),
            matching: find.byType(Scrollable),
          )
          .first;
      await tester.scrollUntilVisible(
        last,
        500,
        scrollable: list,
        maxScrolls: 30,
      );
      await tester.ensureVisible(last);
      await tester.tap(last);
      await tester.pumpAndSettle();
      expect(find.text('Pattern 50'), findsOneWidget);
      expect(find.byKey(const ValueKey('start_challenge')), findsOneWidget);
      appRouter.go('/');
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
    },
  );
}
