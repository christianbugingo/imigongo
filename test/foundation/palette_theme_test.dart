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

  final r = transform(color.r);
  final g = transform(color.g);
  final b = transform(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Calculates the WCAG 2.1 contrast ratio between two colors (1.0 to 21.0).
double _contrastRatio(Color foreground, Color background) {
  final l1 = _calculateLuminance(foreground);
  final l2 = _calculateLuminance(background);
  final lighter = math.max(l1, l2);
  final darker = math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  for (final theme in [ImigongoTheme.lightTheme, ImigongoTheme.darkTheme]) {
    test(
      'Step 4b ${theme.brightness.name}: action and sheet text meets AA',
      () {
        final colors = theme.colorScheme;
        expect(
          _contrastRatio(colors.primary, colors.surface),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrastRatio(colors.onSurface, colors.surface),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrastRatio(colors.onPrimary, colors.primary),
          greaterThanOrEqualTo(4.5),
        );
      },
    );
  }

  group('WCAG AA Contrast Ratio Tests (Dark & Light Themes)', () {
    test('Dark theme: chalk on canvas background meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(
        ImigongoPalette.chalk,
        ImigongoPalette.canvasSlate,
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Dark theme: chalk on tile surface meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(
        ImigongoPalette.chalk,
        ImigongoPalette.tileSurface,
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Dark theme: charcoal on ochre meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(
        ImigongoPalette.charcoal,
        ImigongoPalette.ochre,
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Light theme: charcoal on chalk canvas meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(
        ImigongoPalette.charcoal,
        ImigongoPalette.chalk,
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Light theme: charcoal on parchment card surface meets WCAG AA (>= 4.5:1)', () {
      final ratio = _contrastRatio(
        ImigongoPalette.charcoal,
        ImigongoPalette.parchment,
      );
      expect(ratio, greaterThanOrEqualTo(4.5));
    });

    test('Theme configurations verify brightness and contrast', () {
      final dark = ImigongoTheme.darkTheme;
      expect(dark.brightness, equals(Brightness.dark));
      expect(dark.scaffoldBackgroundColor, equals(ImigongoPalette.canvasSlate));

      final light = ImigongoTheme.lightTheme;
      expect(light.brightness, equals(Brightness.light));
      expect(light.scaffoldBackgroundColor, equals(ImigongoPalette.chalk));
    });
  });
}
