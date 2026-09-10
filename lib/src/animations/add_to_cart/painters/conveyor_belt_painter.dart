import 'package:flutter/material.dart';

/// Paints the factory conveyor belt track with animated rolling teeth,
/// and the top overhead scanner housing with status indicator.
class ConveyorBeltPainter extends CustomPainter {
  final Color trackColor;
  final Color rollerColor;
  final Color scannerColor;
  final Color indicatorColor;
  final double rollProgress; // Continuous 0.0 -> 1.0 for roller movement
  final double entranceProgress; // 0.0 -> 1.0 for track/scanner fade & scale
  final bool isScanning;
  final bool isRtl;

  const ConveyorBeltPainter({
    required this.trackColor,
    required this.rollerColor,
    required this.scannerColor,
    required this.indicatorColor,
    required this.rollProgress,
    required this.entranceProgress,
    this.isScanning = false,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entranceProgress <= 0.01) return;

    final w = size.width;
    final h = size.height;

    final opacity = entranceProgress.clamp(0.0, 1.0);

    // 1. Overhead Scanner Unit (Top Center)
    final scannerWidth = 36.0 * entranceProgress;
    final scannerHeight = 13.0 * entranceProgress;
    final scannerLeft = (w - scannerWidth) / 2;
    final scannerTop = 6.0 + (1.0 - entranceProgress) * -10.0;

    final scannerPaint = Paint()
      ..color = scannerColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final scannerRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(scannerLeft, scannerTop, scannerWidth, scannerHeight),
      const Radius.circular(6.0),
    );
    canvas.drawRRect(scannerRRect, scannerPaint);

    // Subtle dark border for the scanner
    final scannerBorderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25 * opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(scannerRRect, scannerBorderPaint);

    // Lens & Status LED Dot
    if (entranceProgress > 0.6) {
      final lensCenter = Offset(w / 2 - 5, scannerTop + scannerHeight / 2);
      final lensPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.6 * opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(lensCenter, 2.5, lensPaint);

      final ledCenter = Offset(w / 2 + 6, scannerTop + scannerHeight / 2);
      final ledPaint = Paint()
        ..color = (isScanning ? const Color(0xFFEF4444) : indicatorColor)
            .withValues(alpha: opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(ledCenter, 2.0, ledPaint);

      // Glow around LED
      final glowPaint = Paint()
        ..color = (isScanning ? const Color(0xFFEF4444) : indicatorColor)
            .withValues(alpha: 0.4 * opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5);
      canvas.drawCircle(ledCenter, 3.5, glowPaint);
    }

    // 2. Conveyor Belt Track (Bottom)
    final trackY = h * 0.72;
    final trackStartX = 18.0;
    final trackEndX = w - 18.0;
    final trackLength = (trackEndX - trackStartX) * entranceProgress;

    final adjustedStartX = isRtl ? trackEndX - trackLength : trackStartX;
    final adjustedEndX = isRtl ? trackEndX : trackStartX + trackLength;

    final trackPaint = Paint()
      ..color = trackColor.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    canvas.drawLine(
      Offset(adjustedStartX, trackY),
      Offset(adjustedEndX, trackY),
      trackPaint,
    );

    // 3. Conveyor Roller Tick Marks / Teeth
    final rollerPaint = Paint()
      ..color = rollerColor.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    const tickSpacing = 10.0;
    final double offset = (rollProgress * tickSpacing) % tickSpacing;
    final direction = isRtl ? -1.0 : 1.0;

    for (double x = trackStartX + 4.0; x <= trackStartX + trackLength - 4.0; x += tickSpacing) {
      final tickX = x + (offset * direction);
      if (tickX >= trackStartX && tickX <= trackStartX + trackLength) {
        canvas.drawLine(
          Offset(tickX, trackY - 1.5),
          Offset(tickX, trackY + 1.5),
          rollerPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ConveyorBeltPainter oldDelegate) {
    return oldDelegate.rollProgress != rollProgress ||
        oldDelegate.entranceProgress != entranceProgress ||
        oldDelegate.isScanning != isScanning ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.rollerColor != rollerColor ||
        oldDelegate.scannerColor != scannerColor ||
        oldDelegate.indicatorColor != indicatorColor;
  }
}
