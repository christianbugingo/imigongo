import 'package:flutter/material.dart';

/// Authentic color palette representing the traditional Rwandan Imigongo art form.
///
/// Imigongo artists historically used natural mineral and organic pigments:
/// - Uruzi: Black derived from banana peel ash, soot, and charcoal.
/// - Ingwa: White kaolin clay sourced from river beds.
/// - Urukondo: Red-brown iron-rich soil / terracotta clay.
/// - Icyondo: Golden ochre clay.
class ImigongoPalette {
  ImigongoPalette._();

  /// Uruzi: Deep charcoal black (natural ash/soot pigment).
  static const Color uruziBlack = Color(0xFF181716);

  /// Ingwa: Soft chalk white (natural kaolin clay).
  static const Color ingwaWhite = Color(0xFFF7F5EE);

  /// Urukondo: Rich terracotta red (iron-rich Rwandan earth).
  static const Color urukondoRed = Color(0xFFA33824);

  /// Icyondo: Earthy ochre yellow (natural clay pigment).
  static const Color icyondoYellow = Color(0xFFD49B35);

  /// Board background slate (dark mode canvas).
  static const Color canvasSlate = Color(0xFF22201E);

  /// Card/Tile base surface.
  static const Color tileSurface = Color(0xFF2C2A27);

  /// Warm parchment (light accent and UI cards).
  static const Color parchment = Color(0xFFEFE9DB);

  /// Relief highlights simulating traditional sculpted cow-dung ridges.
  static const Color ridgeHighlight = Color(0x33FFFFFF);

  /// Relief shadows simulating sculpted ridge depth.
  static const Color ridgeShadow = Color(0x55000000);

  /// Golden star active color.
  static const Color starGold = Color(0xFFFFB800);

  /// Inactive star color.
  static const Color starInactive = Color(0xFF4A4641);
}
