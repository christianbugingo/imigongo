import 'package:flutter_test/flutter_test.dart';
import 'package:imigongo_pattern_puzzle/core/theme/imigongo_palette.dart';
import 'package:imigongo_pattern_puzzle/core/theme/imigongo_theme.dart';

void main() {
  group('Imigongo Palette Tests', () {
    test('Traditional colors are defined and distinct', () {
      expect(ImigongoPalette.uruziBlack.toARGB32(), equals(0xFF181716));
      expect(ImigongoPalette.ingwaWhite.toARGB32(), equals(0xFFF7F5EE));
      expect(ImigongoPalette.urukondoRed.toARGB32(), equals(0xFFA33824));
      expect(ImigongoPalette.icyondoYellow.toARGB32(), equals(0xFFD49B35));

      // Ensure all 4 core traditional colors are unique
      final set = {
        ImigongoPalette.uruziBlack,
        ImigongoPalette.ingwaWhite,
        ImigongoPalette.urukondoRed,
        ImigongoPalette.icyondoYellow,
      };
      expect(set.length, equals(4));
    });

    test('Theme initializes dark theme with high contrast', () {
      final theme = ImigongoTheme.darkTheme;
      expect(theme.scaffoldBackgroundColor, equals(ImigongoPalette.canvasSlate));
      expect(theme.colorScheme.primary, equals(ImigongoPalette.icyondoYellow));
      expect(theme.colorScheme.secondary, equals(ImigongoPalette.urukondoRed));
    });
  });
}
