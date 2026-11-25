import 'package:flutter/material.dart';

import '../../core/theme/imigongo_palette.dart';
import '../../l10n/app_localizations.dart';
import '../models/puzzle_view.dart';
import '../painters/tile_painter.dart';

/// Single interactive tile on the Imigongo puzzle board.
///
/// Tapping rotates the tile +90 degrees clockwise (the single allowed gameplay control).
class PuzzleTileWidget extends StatelessWidget {
  final TileView tile;
  final VoidCallback? onTap;
  final bool isDark;

  const PuzzleTileWidget({
    super.key,
    required this.tile,
    required this.onTap,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = isDark
        ? ImigongoPalette.tileSurface
        : ImigongoPalette.parchment;
    final ridgeColor = isDark
        ? ImigongoPalette.ochre
        : ImigongoPalette.charcoal;

    final l10n = AppLocalizations.of(context)!;
    final directions = [
      if (tile.north) l10n.north,
      if (tile.east) l10n.east,
      if (tile.south) l10n.south,
      if (tile.west) l10n.west,
    ];
    return Semantics(
      label: l10n.tileLabel(
        tile.row + 1,
        tile.col + 1,
        directions.isEmpty ? l10n.noConnections : directions.join(', '),
      ),
      enabled: onTap != null,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
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
