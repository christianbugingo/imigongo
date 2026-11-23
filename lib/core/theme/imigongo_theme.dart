import 'package:flutter/material.dart';
import 'imigongo_palette.dart';

/// App theme configuration for Imigongo Pattern Puzzle.
class ImigongoTheme {
  ImigongoTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: ImigongoPalette.canvasSlate,
      colorScheme: const ColorScheme.dark(
        primary: ImigongoPalette.icyondoYellow,
        secondary: ImigongoPalette.urukondoRed,
        surface: ImigongoPalette.tileSurface,
        onPrimary: ImigongoPalette.uruziBlack,
        onSecondary: ImigongoPalette.ingwaWhite,
        onSurface: ImigongoPalette.ingwaWhite,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: ImigongoPalette.canvasSlate,
        elevation: 0,
        centerTitle: true,
        foregroundColor: ImigongoPalette.ingwaWhite,
        titleTextStyle: TextStyle(
          color: ImigongoPalette.ingwaWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: ImigongoPalette.tileSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ImigongoPalette.starInactive, width: 1),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: ImigongoPalette.ingwaWhite,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
        headlineMedium: TextStyle(
          color: ImigongoPalette.ingwaWhite,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
        titleLarge: TextStyle(
          color: ImigongoPalette.ingwaWhite,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: ImigongoPalette.ingwaWhite,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: ImigongoPalette.parchment,
          fontSize: 14,
        ),
      ),
    );
  }
}
