import 'package:flutter/material.dart';
import '../../core/theme/imigongo_palette.dart';
import '../../engine/models/connection_mask.dart';
import '../../engine/models/tile.dart';

/// High-performance vector CustomPainter rendering authentic Imigongo geometric relief ridges.
///
/// Simulates sculpted relief ridges with subtle light highlight and depth shadow bevels.
/// Pure mathematical vector canvas rendering: zero bitmap decoding overhead and microscopic memory footprint.
class TilePainter extends CustomPainter {
  final Tile tile;
  final Color ridgeColor;
  final Color surfaceColor;
  final bool isDark;

  TilePainter({
    required this.tile,
    required this.ridgeColor,
    required this.surfaceColor,
    this.isDark = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final strokeWidth = w * 0.24;

    // 1. Draw tile background surface
    final tileRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, w - 2, h - 2),
      const Radius.circular(8),
    );
    final bgPaint = Paint()..color = surfaceColor;
    canvas.drawRRect(tileRect, bgPaint);

    // Subtle tile border
    final borderPaint = Paint()
      ..color = isDark ? Colors.white10 : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(tileRect, borderPaint);

    final mask = tile.effectiveMask;
    if (mask == ConnectionMask.none) return;

    final hasN = ConnectionMask.hasNorth(mask);
    final hasE = ConnectionMask.hasEast(mask);
    final hasS = ConnectionMask.hasSouth(mask);
    final hasW = ConnectionMask.hasWest(mask);

    // Build the geometric path
    final path = Path();

    if (hasN) {
      path.moveTo(center.dx, center.dy);
      path.lineTo(center.dx, 0);
    }
    if (hasE) {
      path.moveTo(center.dx, center.dy);
      path.lineTo(w, center.dy);
    }
    if (hasS) {
      path.moveTo(center.dx, center.dy);
      path.lineTo(center.dx, h);
    }
    if (hasW) {
      path.moveTo(center.dx, center.dy);
      path.lineTo(0, center.dy);
    }

    // Clip to tile rounded boundary
    canvas.save();
    canvas.clipRRect(tileRect);

    // 2. Draw 3D relief depth shadow (offset slightly bottom-right)
    final shadowPaint = Paint()
      ..color = ImigongoPalette.ridgeShadow
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    canvas.save();
    canvas.translate(1.5, 1.5);
    canvas.drawPath(path, shadowPaint);
    canvas.drawCircle(center, strokeWidth / 2, shadowPaint..style = PaintingStyle.fill);
    canvas.restore();

    // 3. Draw 3D relief highlight (offset slightly top-left)
    final highlightPaint = Paint()
      ..color = isDark ? ImigongoPalette.ridgeHighlight : Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    canvas.save();
    canvas.translate(-1.0, -1.0);
    canvas.drawPath(path, highlightPaint);
    canvas.drawCircle(center, strokeWidth / 2, highlightPaint..style = PaintingStyle.fill);
    canvas.restore();

    // 4. Draw primary colored ridge body
    final ridgePaint = Paint()
      ..color = ridgeColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth - 2.0;

    canvas.drawPath(path, ridgePaint);
    canvas.drawCircle(center, (strokeWidth - 2.0) / 2, ridgePaint..style = PaintingStyle.fill);

    // 5. Center relief lozenge / diamond accent for 4-way crossings
    if (mask == ConnectionMask.crossAll) {
      final diamondPath = Path()
        ..moveTo(center.dx, center.dy - strokeWidth * 0.45)
        ..lineTo(center.dx + strokeWidth * 0.45, center.dy)
        ..lineTo(center.dx, center.dy + strokeWidth * 0.45)
        ..lineTo(center.dx - strokeWidth * 0.45, center.dy)
        ..close();

      final accentPaint = Paint()
        ..color = isDark ? ImigongoPalette.chalk : ImigongoPalette.charcoal
        ..style = PaintingStyle.fill;
      canvas.drawPath(diamondPath, accentPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TilePainter oldDelegate) {
    return oldDelegate.tile != tile ||
        oldDelegate.ridgeColor != ridgeColor ||
        oldDelegate.surfaceColor != surfaceColor ||
        oldDelegate.isDark != isDark;
  }
}

