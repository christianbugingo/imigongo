import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/engine/generator/puzzle_generator.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/puzzle_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/screens/puzzle_screen.dart';
import 'package:imigongo_pattern_puzzle/ui/widgets/puzzle_tile_widget.dart';

import 'puzzle_provider_test.dart' show oneTapBoard;

void main() {
  Widget harness({int size = 3}) => ProviderScope(
    overrides: [
      puzzleBoardFactoryProvider.overrideWithValue(
        (size, seed) => size == 3
            ? oneTapBoard()
            : PuzzleGenerator.generate(size: size, seed: seed),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PuzzleScreen(size: size, seed: 1),
    ),
  );

  testWidgets(
    'tap renders rotated mask and counts move; undo/reset update UI',
    (tester) async {
      await tester.pumpWidget(harness());
      final tile = find.byKey(const ValueKey('tile_0_0'));
      expect(tester.widget<PuzzleTileWidget>(tile).tile.mask, 3);
      expect(find.text('Moves: 0'), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(const ValueKey('undo')))
            .onPressed,
        isNull,
      );
      await tester.tap(tile);
      await tester.pump();
      expect(tester.widget<PuzzleTileWidget>(tile).tile.mask, 6);
      expect(find.text('Moves: 1'), findsOneWidget);
      expect(find.text('Solved'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNothing);
      expect(find.text('Next Puzzle'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('undo')));
      await tester.pump();
      expect(find.text('In progress'), findsOneWidget);
      expect(find.text('Moves: 0'), findsOneWidget);
      expect(tester.widget<PuzzleTileWidget>(tile).tile.mask, 3);
      await tester.tap(find.byKey(const ValueKey('tile_0_1')));
      await tester.pump();
      expect(find.text('Moves: 1'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('reset')));
      await tester.pump();
      expect(find.text('Moves: 0'), findsOneWidget);
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(const ValueKey('undo')))
            .onPressed,
        isNull,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('7x7 retains 48 dp tiles on a narrow viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(harness(size: 7));
    final size = tester.getSize(find.byKey(const ValueKey('tile_0_0')));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
    expect(tester.takeException(), isNull);
  });
}
