import 'package:flutter/material.dart';

import 'imigongo_palette.dart';

class PatternInk {
  final Color surface, ridge, outline;
  const PatternInk({
    required this.surface,
    required this.ridge,
    required this.outline,
  });
}

/// Cosmetic only: the same coordinate/palette mapping is used in every preview.
class PatternPalette {
  static const ids = ['classic', 'clay', 'ochre', 'mixed', 'inverse'];
  static PatternInk resolve(String id, bool dark, int row, int col) {
    final inverted = id == 'inverse';
    final lightSurface = inverted ? dark : !dark;
    final surface = lightSurface
        ? ImigongoPalette.parchment
        : ImigongoPalette.tileSurface;
    final outline = lightSurface
        ? ImigongoPalette.charcoal
        : ImigongoPalette.chalk;
    final ridge = switch (id) {
      'clay' => ImigongoPalette.terracotta,
      'ochre' => ImigongoPalette.ochre,
      'mixed' => [
        ImigongoPalette.ochre,
        ImigongoPalette.terracotta,
        outline,
      ][(row + col) % 3],
      'inverse' => outline,
      _ => dark ? ImigongoPalette.ochre : ImigongoPalette.charcoal,
    };
    return PatternInk(surface: surface, ridge: ridge, outline: outline);
  }
}
