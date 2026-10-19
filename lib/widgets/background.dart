import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import 'common.dart';

/// Fond fixe : halos colorés qui dérivent lentement, façon braises.
class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: LoopAnimation(
        duration: const Duration(seconds: 24),
        builder: (context, t) =>
            CustomPaint(painter: _EmberPainter(t), size: Size.infinite),
      ),
    );
  }
}

class _EmberPainter extends CustomPainter {
  _EmberPainter(this.t);

  final double t;

  // Position (fraction de l'écran), rayon (fraction du plus grand côté), opacité.
  static const _blobs = [
    (color: AppColors.orange, x: 0.12, y: 0.08, r: 0.55, a: 0.16, phase: 0.0),
    (color: AppColors.ember, x: 0.88, y: 0.30, r: 0.50, a: 0.13, phase: 0.33),
    (color: AppColors.violet, x: 0.80, y: 0.92, r: 0.55, a: 0.14, phase: 0.66),
    (color: AppColors.amber, x: 0.18, y: 0.78, r: 0.35, a: 0.08, phase: 0.5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.bg);
    final unit = math.max(size.width, size.height);
    for (final blob in _blobs) {
      final angle = 2 * math.pi * (t + blob.phase);
      final center = Offset(
        size.width * (blob.x + 0.08 * math.sin(angle)),
        size.height * (blob.y + 0.06 * math.cos(angle)),
      );
      final radius = unit * blob.r;
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            blob.color.withValues(alpha: blob.a),
            blob.color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(_EmberPainter oldDelegate) => oldDelegate.t != t;
}
