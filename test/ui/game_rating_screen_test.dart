import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/services/game_rating.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/rating_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/settings_screen.dart';

import '../services/game_rating_test.dart' show FakeRatingGateway;

Future<void> showSettings(WidgetTester tester, GameRating rating) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [gameRatingProvider.overrideWithValue(rating)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SettingsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.scrollUntilVisible(find.byKey(const ValueKey('rate_game')), 250);
}

void main() {
  testWidgets(
    'unreleased rating row explains why it is unavailable and has no action',
    (tester) async {
      final gateway = FakeRatingGateway();
      await showSettings(
        tester,
        GameRating(
          gateway: gateway,
          platform: TargetPlatform.iOS,
          config: const RatingConfiguration(production: true),
        ),
      );
      final row = tester.widget<ListTile>(
        find.byKey(const ValueKey('rate_game')),
      );
      expect(row.enabled, isFalse);
      expect(row.onTap, isNull);
      expect(
        find.text('Available after the game is released in the app store.'),
        findsOneWidget,
      );
      expect(gateway.calls, isEmpty);
    },
  );
  testWidgets(
    'configured rating launches listing and reports failures without claiming a review',
    (tester) async {
      final gateway = FakeRatingGateway()..fail = true;
      await showSettings(
        tester,
        GameRating(
          gateway: gateway,
          platform: TargetPlatform.iOS,
          config: const RatingConfiguration(
            production: true,
            iosListingReady: true,
            appStoreId: '123456789',
          ),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('rate_game')));
      await tester.pumpAndSettle();
      expect(
        find.text('Could not open the app store. Please try again.'),
        findsOneWidget,
      );
      expect(gateway.calls, ['123456789']);
      gateway.fail = false;
      await tester.tap(find.byKey(const ValueKey('rate_game')));
      await tester.pumpAndSettle();
      expect(gateway.calls, ['123456789', '123456789']);
      expect(tester.takeException(), isNull);
    },
  );
}
