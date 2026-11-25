import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/puzzle_view.dart';
import 'puzzle_tile_widget.dart';

/// Layout only: scroll rather than shrink any tile below 48 dp.
class PuzzleBoardWidget extends StatelessWidget {
  final PuzzleState state;
  final void Function(int row, int col) onRotateTile;
  final bool isDark;
  const PuzzleBoardWidget({
    super.key,
    required this.state,
    required this.onRotateTile,
    this.isDark = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minSide = state.size * 48.0 + (state.size - 1) * 4;
        final side = math.max(
          minSide,
          math.min(
            520.0,
            math.min(constraints.maxWidth, constraints.maxHeight),
          ),
        );
        return SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox.square(
              dimension: side,
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: state.size,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: state.tiles.length,
                itemBuilder: (context, index) {
                  final tile = state.tiles[index];
                  return PuzzleTileWidget(
                    key: ValueKey('tile_${tile.row}_${tile.col}'),
                    tile: tile,
                    isDark: isDark,
                    onTap: state.phase != PlayPhase.playing || state.isSolved
                        ? null
                        : () => onRotateTile(tile.row, tile.col),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
