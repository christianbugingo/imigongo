import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/main.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/home_screen.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/settings_screen.dart';

void main() {
  group('Router and Screen Navigation Tests', () {
    testWidgets('App launches on HomeScreen with title and Play button', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: ImigongoPuzzleApp()));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('PLAY'), findsOneWidget);
      expect(find.text('Select Grid Dimension (3x3 through 7x7)'), findsOneWidget);
    });

    testWidgets('Navigates to SettingsScreen when settings icon is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: ImigongoPuzzleApp()));
      await tester.pumpAndSettle();

      final settingsButton = find.byTooltip('Settings');
      expect(settingsButton, findsOneWidget);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.text('Appearance'), findsOneWidget);
      expect(find.text('Language / Ururimi'), findsOneWidget);
    });
  });
}

