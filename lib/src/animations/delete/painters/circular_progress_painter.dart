import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints a circular progress indicator arc that sweeps around the collapsed circle.
class CircularProgressPainter extends CustomPainter {
  /// Progress from 0.0 to 1.0 representing full circular rotation.
  final double progress;

  /// Primary color for the spinning arc.
  final Color progressColor;

  /// Background track color beneath the arc.
  final Color trackColor;

  /// Thickness of the progress arc stroke.
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.trackColor,
    this.strokeWidth = 3.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // 1. Draw subtle background track ring
    if (trackColor.a > 0.0) {
      final Paint trackPaint = Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, radius, trackPaint);
    }

    // 2. Draw active sweeping arc
    if (progress > 0.0) {
      final Paint progressPaint = Paint()
        ..color = progressColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Start from top (-pi / 2) and sweep clockwise
      const double startAngle = -math.pi / 2;
      final double sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
