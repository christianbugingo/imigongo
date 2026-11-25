import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/theme/pattern_palette.dart';
import 'package:imigongo_pattern_puzzle/engine/content/challenge_catalog.dart';
import 'package:imigongo_pattern_puzzle/l10n/app_localizations.dart';
import 'package:imigongo_pattern_puzzle/ui/models/puzzle_view.dart';
import 'package:imigongo_pattern_puzzle/ui/painters/tile_painter.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/puzzle_provider.dart';
import 'package:imigongo_pattern_puzzle/ui/widgets/pattern_image.dart';
import 'package:imigongo_pattern_puzzle/ui/widgets/puzzle_tile_widget.dart';

void main() {
  test(
    'all palette outlines contrast with surfaces in light and dark themes',
    () {
      for (final id in PatternPalette.ids) {
        for (final dark in [false, true]) {
          for (var i = 0; i < 3; i++) {
            final colors = PatternPalette.resolve(id, dark, 0, i);
            final a = colors.outline.computeLuminance(),
                b = colors.surface.computeLuminance();
            final ratio = ((a > b ? a : b) + 0.05) / ((a > b ? b : a) + 0.05);
            expect(ratio, greaterThanOrEqualTo(4.5), reason: '$id dark=$dark');
          }
        }
      }
      expect(
        {
          for (var i = 0; i < 3; i++)
            PatternPalette.resolve('mixed', false, 0, i).ridge,
        }.length,
        3,
      );
    },
  );

  test('palette metadata does not alter domain boards or validity', () {
    const a = ChallengeLevel(
      'test',
      1,
      5,
      26000,
      ChallengeTier.medium,
      null,
      generatorVersion: 3,
      paletteId: 'mixed',
    );
    const b = ChallengeLevel(
      'test',
      1,
      5,
      26000,
      ChallengeTier.medium,
      null,
      generatorVersion: 3,
      paletteId: 'clay',
    );
    expect(a.generate().toJson(), b.generate().toJson());
  });

  test('palette metadata survives controller moves/reset without changing puzzle identity', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(challengePuzzleProvider('easy-4'), (_, _) {});
    final before = container.read(challengePuzzleProvider('easy-4'));
    expect(
      before.paletteId,
      container.read(patternViewProvider('easy-4'))!.paletteId,
    );
    container.read(challengePuzzleProvider('easy-4').notifier).rotateTile(0, 0);
    container.read(challengePuzzleProvider('easy-4').notifier).reset();
    final after = container.read(challengePuzzleProvider('easy-4'));
    expect(after.paletteId, before.paletteId);
    expect(after.tiles.map((t) => t.mask), before.tiles.map((t) => t.mask));
  });

  testWidgets(
    'reference and playing tile share identical ink for each palette/theme',
    (tester) async {
      const tile = TileView(
        row: 0,
        col: 0,
        mask: 6,
        north: false,
        east: true,
        south: true,
        west: false,
      );
      for (final id in PatternPalette.ids) {
        for (final dark in [false, true]) {
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(
                brightness: dark ? Brightness.dark : Brightness.light,
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: Row(
                  children: [
                    SizedBox.square(
                      dimension: 100,
                      child: PatternImage(
                        tiles: const [tile],
                        size: 1,
                        label: 'reference',
                        paletteId: id,
                      ),
                    ),
                    SizedBox.square(
                      dimension: 100,
                      child: PuzzleTileWidget(
                        tile: tile,
                        onTap: () {},
                        isDark: dark,
                        paletteId: id,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final painters = tester
              .widgetList<CustomPaint>(find.byType(CustomPaint))
              .map((w) => w.painter)
              .whereType<TilePainter>()
              .toList();
          expect(painters.length, 2);
          expect(painters[0].ridgeColor, painters[1].ridgeColor);
          expect(painters[0].surfaceColor, painters[1].surfaceColor);
          expect(painters[0].outlineColor, painters[1].outlineColor);
        }
      }
      await tester.pumpWidget(const SizedBox());
    },
  );
}
