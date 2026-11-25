import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/theme/imigongo_theme.dart';
import 'package:imigongo_pattern_puzzle/engine/generator/puzzle_generator.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/puzzle_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/puzzle_screen.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/how_to_play_screen.dart';
import 'package:imigongo_pattern_puzzle/ui/widgets/puzzle_tile_widget.dart';

import 'puzzle_provider_test.dart' show oneTapBoard;

void main() {
  Widget harness({
    int size = 3,
    bool reduced = false,
    double scale = 1,
    Locale locale = const Locale('en'),
  }) => ProviderScope(
    overrides: [
      puzzleBoardFactoryProvider.overrideWithValue(
        (size, seed) => size == 3
            ? oneTapBoard()
            : PuzzleGenerator.generate(size: size, seed: seed),
      ),
    ],
    child: MaterialApp(
      locale: locale,
      theme: ImigongoTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: reduced,
          textScaler: TextScaler.linear(scale),
        ),
        child: child!,
      ),
      home: PuzzleScreen(size: size, seed: 1),
    ),
  );

  testWidgets(
    'tap renders rotation; undo and restart update HUD before completion',
    (tester) async {
      await tester.pumpWidget(harness());
      final tile = find.byKey(const ValueKey('tile_0_1'));
      final before = tester.widget<PuzzleTileWidget>(tile).tile.mask;
      await tester.tap(tile);
      await tester.pump();
      expect(tester.widget<PuzzleTileWidget>(tile).tile.mask, isNot(before));
      expect(find.text('Moves: 1'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('undo')));
      await tester.pump();
      expect(find.text('Moves: 0'), findsOneWidget);
      expect(tester.widget<PuzzleTileWidget>(tile).tile.mask, before);
      await tester.tap(tile);
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('reset')));
      await tester.pump();
      expect(find.text('Moves: 0'), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(const ValueKey('undo')))
            .onPressed,
        isNull,
      );
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'result appears once after hold; announces once; replay starts fresh',
    (tester) async {
      final messages = <Object?>[];
      tester.binding.defaultBinaryMessenger
          .setMockDecodedMessageHandler<Object?>(SystemChannels.accessibility, (
            message,
          ) async {
            messages.add(message);
            return null;
          });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger
            .setMockDecodedMessageHandler<Object?>(
              SystemChannels.accessibility,
              null,
            ),
      );
      await tester.pumpWidget(harness());
      await tester.tap(find.byKey(const ValueKey('tile_0_0')));
      await tester.pump();
      expect(find.byKey(const ValueKey('result_title')), findsNothing);
      await tester.pump(const Duration(milliseconds: 900));
      expect(find.byKey(const ValueKey('result_title')), findsNothing);
      await tester.pump(const Duration(milliseconds: 101));
      await tester.pumpAndSettle();
      expect(find.text('Level complete'), findsOneWidget);
      expect(find.text('New best'), findsOneWidget);
      expect(find.text('Next puzzle'), findsOneWidget);
      final announcements = messages.where(
        (m) => m is Map && m['type'] == 'announce',
      );
      expect(announcements.length, 1);
      expect(
        announcements.single.toString(),
        contains('Level complete, 3 stars'),
      );
      await tester.pump(const Duration(seconds: 2));
      expect(announcements.length, 1);
      await tester.tap(find.byKey(const ValueKey('result_replay')));
      await tester.pumpAndSettle();
      expect(find.text('Moves: 0'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('tile_0_0')));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('New best'), findsNothing);
      expect(announcements.length, 2);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'reduced motion removes hold and star animations; French strings complete',
    (tester) async {
      await tester.pumpWidget(
        harness(reduced: true, locale: const Locale('fr')),
      );
      await tester.tap(find.byKey(const ValueKey('tile_0_0')));
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('Niveau terminé'), findsOneWidget);
      expect(find.text('Puzzle suivant'), findsOneWidget);
      expect(tester.binding.hasScheduledFrame, isFalse);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'pause opens help, back returns to pause, Resume unblocks board',
    (tester) async {
      await tester.pumpWidget(harness());
      await tester.tap(find.byKey(const ValueKey('pause')));
      await tester.pumpAndSettle();
      expect(find.text('Paused'), findsOneWidget);
      await tester.tap(find.text('How to Play'));
      await tester.pumpAndSettle();
      expect(find.byType(HowToPlayScreen), findsOneWidget);
      expect(
        find.text('Tap a tile to turn it a quarter turn clockwise.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Paused'), findsOneWidget);
      await tester.tap(find.text('Resume'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('tile_0_1')));
      await tester.pump();
      expect(find.text('Moves: 1'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'French board semantics expose coordinates and connection directions',
    (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        harness(reduced: true, locale: const Locale('fr')),
      );
      await tester.pumpAndSettle();
      final data = tester
          .getSemantics(find.byKey(const ValueKey('tile_0_0')))
          .getSemanticsData();
      expect(data.label, contains('ligne 1, colonne 1'));
      expect(data.label, contains('nord, est'));
      await tester.pumpWidget(const SizedBox());
      semantics.dispose();
    },
  );

  testWidgets(
    '7x7 supports narrow viewport and doubled text without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(320, 650);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(harness(size: 7, scale: 2));
      final tileSize = tester.getSize(find.byKey(const ValueKey('tile_0_0')));
      expect(tileSize.width, greaterThanOrEqualTo(48));
      expect(tileSize.height, greaterThanOrEqualTo(48));
      expect(
        tester.getSize(find.byKey(const ValueKey('pause'))).height,
        greaterThanOrEqualTo(48),
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
