import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/theme/pattern_palette.dart';
import 'package:imigongo_pattern_puzzle/engine/content/challenge_catalog.dart';
import 'package:imigongo_pattern_puzzle/ui/painters/tile_painter.dart';
import 'package:imigongo_pattern_puzzle/ui/providers/puzzle_provider.dart';

/// Developer review export, using the production painter and palette resolver.
/// FLUTTER_ROOT must point to the installed SDK for its licensed Roboto font.
void main() {
  testWidgets(
    'render 50 production pattern previews for light and dark review',
    (tester) async {
      await tester.runAsync(() async {
        final root = Platform.environment['FLUTTER_ROOT'];
        if (root == null) {
          throw StateError('Set FLUTTER_ROOT to the Flutter SDK path');
        }
        final bytes = File(
          '$root/bin/cache/artifacts/material_fonts/Roboto-Regular.ttf',
        ).readAsBytesSync();
        await (FontLoader(
          'CatalogReview',
        )..addFont(Future.value(ByteData.sublistView(bytes)))).load();
        final container = ProviderContainer();
        try {
          for (final dark in [false, true]) {
            final recorder = ui.PictureRecorder();
            final canvas = Canvas(recorder);
            canvas.drawRect(
              const Rect.fromLTWH(0, 0, 1000, 2200),
              Paint()
                ..color = dark
                    ? const Color(0xFF181716)
                    : const Color(0xFFF7F5EE),
            );
            for (var i = 0; i < ChallengeCatalog.levels.length; i++) {
              final level = ChallengeCatalog.levels[i];
              final view = container.read(patternViewProvider(level.id))!;
              final x = (i % 5) * 200.0 + 14, y = (i ~/ 5) * 220.0 + 10;
              final title = TextPainter(
                text: TextSpan(
                  text:
                      '${level.number}  ${level.tier.name}  ${level.paletteId}',
                  style: TextStyle(
                    fontFamily: 'CatalogReview',
                    fontSize: 12,
                    color: dark ? Colors.white : Colors.black,
                  ),
                ),
                textDirection: TextDirection.ltr,
              )..layout(maxWidth: 180);
              title.paint(canvas, Offset(x, y));
              final side = 170.0 / view.size;
              for (final tile in view.tiles) {
                final ink = PatternPalette.resolve(
                  view.paletteId,
                  dark,
                  tile.row,
                  tile.col,
                );
                canvas.save();
                canvas.translate(x + tile.col * side, y + 28 + tile.row * side);
                TilePainter(
                  tile: tile,
                  ridgeColor: ink.ridge,
                  surfaceColor: ink.surface,
                  outlineColor: ink.outline,
                  isDark: dark,
                ).paint(canvas, Size.square(side));
                canvas.restore();
              }
            }
            final picture = recorder.endRecording();
            final image = await picture.toImage(1000, 2200);
            final png = await image.toByteData(format: ui.ImageByteFormat.png);
            File('docs/verification/catalog-${dark ? 'dark' : 'light'}.png')
                .writeAsBytesSync(png!.buffer.asUint8List());
            image.dispose();
            picture.dispose();
          }
        } finally {
          container.dispose();
        }
      });
    },
  );
}
