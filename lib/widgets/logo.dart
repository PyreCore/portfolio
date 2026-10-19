import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Logo PyreCore : une flamme au cœur d'un hexagone, en dégradé feu.
/// Même géométrie que web/favicon.svg (repère 100 × 100).
class PyreLogo extends StatelessWidget {
  const PyreLogo({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _LogoPainter(core: context.colors.bg),
    );
  }
}

class _LogoPainter extends CustomPainter {
  const _LogoPainter({required this.core});

  /// Couleur du cœur de la flamme : celle du fond, pour un effet « percé ».
  final Color core;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
    final shader = AppGradients.fire.createShader(
      const Rect.fromLTWH(0, 0, 100, 100),
    );

    final hexagon = Path();
    for (var i = 0; i < 6; i++) {
      final angle = math.pi / 3 * i - math.pi / 2;
      final point = Offset(50 + 43 * math.cos(angle), 50 + 43 * math.sin(angle));
      i == 0
          ? hexagon.moveTo(point.dx, point.dy)
          : hexagon.lineTo(point.dx, point.dy);
    }
    hexagon.close();
    canvas.drawPath(
      hexagon,
      Paint()
        ..shader = shader
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeJoin = StrokeJoin.round,
    );

    final flame = Path()
      ..moveTo(50, 22)
      ..cubicTo(58, 34, 69, 43, 69, 58)
      ..cubicTo(69, 70, 60, 78, 50, 78)
      ..cubicTo(40, 78, 31, 70, 31, 58)
      ..cubicTo(31, 50, 36, 44, 41, 39)
      ..cubicTo(41, 46, 44, 51, 48, 52)
      ..cubicTo(45, 42, 46, 31, 50, 22)
      ..close();
    canvas.drawPath(flame, Paint()..shader = shader);

    // Le « cœur » sombre au centre de la flamme.
    canvas.drawCircle(const Offset(50, 63), 7, Paint()..color = core);
  }

  @override
  bool shouldRepaint(_LogoPainter oldDelegate) => oldDelegate.core != core;
}
