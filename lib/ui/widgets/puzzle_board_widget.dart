import 'package:flutter/material.dart';
import '../../core/theme/imigongo_palette.dart';
import '../../engine/models/board.dart';
import 'puzzle_tile_widget.dart';

/// Full interactive NxN board widget.
class PuzzleBoardWidget extends StatelessWidget {
  final Board board;
  final void Function(int row, int col) onRotateTile;
  final bool isDark;

  const PuzzleBoardWidget({
    super.key,
    required this.board,
    required this.onRotateTile,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = board.size;
    final outerFrameColor = isDark ? ImigongoPalette.charcoal : ImigongoPalette.parchment;
    final borderColor = isDark ? ImigongoPalette.starInactive : ImigongoPalette.terracotta;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Keep board square and properly constrained
          final maxSide = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;
          final boardSide = (maxSide * 0.95).clamp(240.0, 520.0);

          return Container(
            width: boardSide,
            height: boardSide,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: outerFrameColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: size * size,
              itemBuilder: (context, index) {
                final r = index ~/ size;
                final c = index % size;
                final tile = board.tileAt(r, c);

                return PuzzleTileWidget(
                  key: ValueKey('tile_${r}_$c'),
                  tile: tile,
                  isDark: isDark,
                  onTap: () => onRotateTile(r, c),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

