import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/main.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';
import 'package:imigongo_pattern_puzzle/core/services/game_settings.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/settings_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/onboarding_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/routing/app_router.dart';

import '../support/tutorial_preferences.dart';

void main() {
  testWidgets('selecting Kinyarwanda from Settings keeps the app usable', (
    tester,
  ) async {
    appRouter.go('/');
    final container = ProviderContainer(
      overrides: [
        tutorialPreferencesProvider.overrideWithValue(
          MemoryTutorialPreferences(finished: true),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ImigongoPuzzleApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();
    final english = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.tap(find.text(english.rwReviewLabel).last);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(container.read(settingsProvider).language, 'rw');
    expect(find.byType(SwitchListTile), findsNWidgets(3));
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await container
        .read(settingsProvider.notifier)
        .update(const GameSettings(language: 'fr'));
    await tester.pumpAndSettle();
    expect(find.text('Facile'), findsOneWidget);
    appRouter.go('/');
  });
  testWidgets('a saved Kinyarwanda preference starts with working controls', (
    tester,
  ) async {
    appRouter.go('/');
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initialSettingsProvider.overrideWithValue(
            const GameSettings(language: 'rw'),
          ),
          tutorialPreferencesProvider.overrideWithValue(
            MemoryTutorialPreferences(finished: true),
          ),
        ],
        child: const ImigongoPuzzleApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final context = tester.element(find.byType(Scaffold).first);
    expect(Localizations.localeOf(context).languageCode, 'rw');
    expect(AppLocalizations.of(context)!.localeName, 'rw');
    expect(MaterialLocalizations.of(context).backButtonTooltip, 'Back');
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    final rw = await AppLocalizations.delegate.load(const Locale('rw'));
    await tester.scrollUntilVisible(find.text(rw.resetProgress), 250);
    await tester.tap(find.text(rw.resetProgress));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text(rw.cancelSetting));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    appRouter.go('/');
  });
}
