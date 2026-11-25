import 'package:flutter/material.dart';

import '../../core/theme/pattern_palette.dart';
import '../models/puzzle_view.dart';
import '../painters/tile_painter.dart';

/// A static procedural reference, not an interactive game board or bitmap.
class PatternImage extends StatelessWidget {
  final List<TileView> tiles;
  final int size;
  final String label;
  final String paletteId;
  const PatternImage({
    super.key,
    required this.tiles,
    required this.size,
    required this.label,
    this.paletteId = 'classic',
  });
  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: label,
    child: ExcludeSemantics(
      child: AspectRatio(
        aspectRatio: 1,
        child: RepaintBoundary(
          child: GridView.count(
            crossAxisCount: size,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final tile in tiles)
                CustomPaint(
                  painter: TilePainter(
                    tile: tile,
                    ridgeColor: PatternPalette.resolve(
                      paletteId,
                      Theme.of(context).brightness == Brightness.dark,
                      tile.row,
                      tile.col,
                    ).ridge,
                    outlineColor: PatternPalette.resolve(
                      paletteId,
                      Theme.of(context).brightness == Brightness.dark,
                      tile.row,
                      tile.col,
                    ).outline,
                    surfaceColor: PatternPalette.resolve(
                      paletteId,
                      Theme.of(context).brightness == Brightness.dark,
                      tile.row,
                      tile.col,
                    ).surface,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
