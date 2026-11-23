import 'package:flutter/material.dart';
import '../../core/theme/imigongo_palette.dart';
import '../../engine/models/tile.dart';
import '../painters/tile_painter.dart';

/// Single interactive tile on the Imigongo puzzle board.
///
/// Tapping rotates the tile +90 degrees clockwise (the single allowed gameplay control).
class PuzzleTileWidget extends StatelessWidget {
  final Tile tile;
  final VoidCallback onTap;
  final bool isDark;

  const PuzzleTileWidget({
    super.key,
    required this.tile,
    required this.onTap,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark ? ImigongoPalette.tileSurface : ImigongoPalette.parchment;
    final ridgeColor = isDark ? ImigongoPalette.ochre : ImigongoPalette.charcoal;

    return Semantics(
      label: 'Tile at row ${tile.row}, column ${tile.col}. Tap to rotate clockwise.',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 1.0,
          child: CustomPaint(
            painter: TilePainter(
              tile: tile,
              ridgeColor: ridgeColor,
              surfaceColor: surfaceColor,
              isDark: isDark,
            ),
          ),
        ),
      ),
    );
  }
}

