import 'package:flutter/material.dart';

/// Color palette inspired by Imigongo geometric art.
///
/// Plain English color identifiers are used. Cultural attributions and historical
/// names are documented separately in docs/CULTURAL_REVIEW.md pending native review.
class ImigongoPalette {
  ImigongoPalette._();

  /// Charcoal black tone.
  static const Color charcoal = Color(0xFF181716);

  /// Off-white chalk tone.
  static const Color chalk = Color(0xFFF7F5EE);

  /// Terracotta red-brown tone.
  static const Color terracotta = Color(0xFFA33824);

  /// Ochre yellow tone.
  static const Color ochre = Color(0xFFD49B35);

  /// Board background slate (dark mode canvas).
  static const Color canvasSlate = Color(0xFF22201E);

  /// Card and tile base surface.
  static const Color tileSurface = Color(0xFF2C2A27);

  /// Warm parchment tone (light accent and UI cards).
  static const Color parchment = Color(0xFFEFE9DB);

  /// Relief highlight tone for simulated 3D ridges.
  static const Color ridgeHighlight = Color(0x33FFFFFF);

  /// Relief shadow tone for simulated 3D ridge depth.
  static const Color ridgeShadow = Color(0x55000000);

  /// Active star color.
  static const Color starGold = Color(0xFFFFB800);

  /// Inactive star color.
  static const Color starInactive = Color(0xFF4A4641);
}
