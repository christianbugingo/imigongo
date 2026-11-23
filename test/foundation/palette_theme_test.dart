import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/theme/imigongo_palette.dart';
import 'package:imigongo_pattern_puzzle/core/theme/imigongo_theme.dart';

/// Calculates the WCAG 2.1 relative luminance of a Color.
double _calculateLuminance(Color color) {
  double transform(double channel) {
    return channel <= 0.04045
        ? channel / 12.92
        : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  // Use component accessors [0.0, 1.0]
  final r = transform(color.r);
  final g = transform(color.g);
  final b = transform(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Calculates the WCAG 2.1 contrast ratio between two colors (ranging from 1.0 to 21.0).
double _contrastRatio(Color foreground, Color background) {
  final l1 = _calculateLuminance(foreground);
  final l2 = _calculateLuminance(background);
  final lighter = math.max(l1, l2);
  final darker = math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('WCAG AA Contrast Ratio Tests', () {
    test('Primary body text (chalk) on canvas background meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(ImigongoPalette.chalk, ImigongoPalette.canvasSlate);
      // Expected ratio is ~14.8:1
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Chalk text on canvasSlate must satisfy WCAG AA contrast');
    });

    test('Primary body text (chalk) on tile surface meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(ImigongoPalette.chalk, ImigongoPalette.tileSurface);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Chalk text on tileSurface must satisfy WCAG AA contrast');
    });

    test('Secondary body text (parchment) on tile surface meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(ImigongoPalette.parchment, ImigongoPalette.tileSurface);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Parchment text on tileSurface must satisfy WCAG AA contrast');
    });

    test('Accent button text (charcoal on ochre) meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(ImigongoPalette.charcoal, ImigongoPalette.ochre);
      expect(ratio, greaterThanOrEqualTo(4.5),
          reason: 'Charcoal text on ochre button surface must satisfy WCAG AA contrast');
    });

    test('Theme darkTheme configures high-contrast color scheme', () {
      final theme = ImigongoTheme.darkTheme;
      expect(theme.scaffoldBackgroundColor, equals(ImigongoPalette.canvasSlate));
      expect(theme.colorScheme.onSurface, equals(ImigongoPalette.chalk));
      expect(theme.colorScheme.primary, equals(ImigongoPalette.ochre));
    });
  });
}
