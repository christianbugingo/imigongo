import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/main.dart';
import 'package:imigongo_pattern_puzzle/ui/routing/app_router.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/home_screen.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/puzzle_screen.dart';

void main() {
  testWidgets('prototype offers only size selection and Step 4a gameplay', (
    tester,
  ) async {
    appRouter.go('/');
    await tester.pumpWidget(const ProviderScope(child: ImigongoPuzzleApp()));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsNothing);
    await tester.tap(find.text('6x6'));
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();
    expect(find.byType(PuzzleScreen), findsOneWidget);
    expect(find.text('6×6'), findsOneWidget);
    expect(find.text('Moves: 0'), findsOneWidget);
    expect(tester.takeException(), isNull);
    appRouter.go('/');
    await tester.pumpAndSettle();
  });
}
