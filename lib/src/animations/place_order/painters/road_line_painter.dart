import 'package:flutter/material.dart';

/// Custom painter for drawing animated dashed road lane divider lines.
class RoadLinePainter extends CustomPainter {
  final Color roadLineColor;
  final double progress;
  final bool isRtl;

  const RoadLinePainter({
    required this.roadLineColor,
    required this.progress,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.0) return;

    final centerY = size.height / 2;
    final totalWidth = size.width;
    final paint = Paint()
      ..color = roadLineColor.withValues(alpha: progress.clamp(0.0, 1.0))
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const dashLength = 8.0;
    const dashGap = 6.0;
    const segment = dashLength + dashGap;

    // How far the dashed road line has progressed
    final currentDrawLength = totalWidth * progress.clamp(0.0, 1.0);

    if (isRtl) {
      double currentX = totalWidth;
      while (currentX > (totalWidth - currentDrawLength)) {
        final drawEnd = (currentX - dashLength).clamp(
          totalWidth - currentDrawLength,
          totalWidth,
        );
        if (currentX > drawEnd) {
          canvas.drawLine(
            Offset(currentX, centerY),
            Offset(drawEnd, centerY),
            paint,
          );
        }
        currentX -= segment;
      }
    } else {
      double currentX = 0.0;
      while (currentX < currentDrawLength) {
        final drawEnd = (currentX + dashLength).clamp(0.0, currentDrawLength);
        if (drawEnd > currentX) {
          canvas.drawLine(
            Offset(currentX, centerY),
            Offset(drawEnd, centerY),
            paint,
          );
        }
        currentX += segment;
      }
    }
  }

  @override
  bool shouldRepaint(covariant RoadLinePainter oldDelegate) {
    return oldDelegate.roadLineColor != roadLineColor ||
        oldDelegate.progress != progress ||
        oldDelegate.isRtl != isRtl;
  }
}
