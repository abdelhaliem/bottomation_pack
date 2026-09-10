import 'package:flutter/material.dart';

/// Paints an animated checkmark that dynamically draws its stroke from left to right
/// with an elastic spring pop effect for the success state.
class SuccessCheckmarkPainter extends CustomPainter {
  /// Animation progress from 0.0 to 1.0.
  final double progress;

  /// Checkmark stroke color.
  final Color color;

  /// Stroke width for the checkmark line.
  final double strokeWidth;

  SuccessCheckmarkPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 3.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.01) return;

    final double width = size.width;
    final double height = size.height;

    // Checkmark landmark coordinates
    final Offset p1 = Offset(width * 0.28, height * 0.52);
    final Offset p2 = Offset(width * 0.44, height * 0.69);
    final Offset p3 = Offset(width * 0.73, height * 0.34);

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path path = Path();
    path.moveTo(p1.dx, p1.dy);

    // Leg 1: p1 to p2 (0.0 -> 0.4 progress)
    // Leg 2: p2 to p3 (0.4 -> 1.0 progress)
    if (progress <= 0.4) {
      final double t = (progress / 0.4).clamp(0.0, 1.0);
      final double curX = p1.dx + (p2.dx - p1.dx) * t;
      final double curY = p1.dy + (p2.dy - p1.dy) * t;
      path.lineTo(curX, curY);
    } else {
      path.lineTo(p2.dx, p2.dy);
      final double t = ((progress - 0.4) / 0.6).clamp(0.0, 1.0);
      final double curX = p2.dx + (p3.dx - p2.dx) * t;
      final double curY = p2.dy + (p3.dy - p2.dy) * t;
      path.lineTo(curX, curY);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SuccessCheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
