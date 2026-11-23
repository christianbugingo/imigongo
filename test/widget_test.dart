import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/config/app_flavor.dart';
import 'package:imigongo_pattern_puzzle/main.dart';

void main() {
  testWidgets('Imigongo puzzle app loads with localization and prod flavor', (WidgetTester tester) async {
    AppConfig.initialize(AppFlavor.prod);
    await tester.pumpWidget(const ProviderScope(child: ImigongoPuzzleApp()));
    await tester.pumpAndSettle();

    // Verify localized title
    expect(find.text('Imigongo Puzzle'), findsOneWidget);

    // Verify section header
    expect(find.text('Geometric Relief Puzzle'), findsOneWidget);

    // Verify Play button
    expect(find.text('PLAY'), findsOneWidget);
  });

  testWidgets('Imigongo puzzle app displays DEV badge when in dev flavor', (WidgetTester tester) async {
    AppConfig.initialize(AppFlavor.dev);
    await tester.pumpWidget(const ProviderScope(child: ImigongoPuzzleApp()));
    await tester.pumpAndSettle();

    expect(find.text('DEV'), findsOneWidget);

    // Reset to prod
    AppConfig.initialize(AppFlavor.prod);
  });
}
