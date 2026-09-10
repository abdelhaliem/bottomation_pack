import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints the cardboard shipping box with dynamic opening/closing flaps,
/// barcode stripes, stamped shipping label, and overhead laser scanning beam.
class FactoryBoxPainter extends CustomPainter {
  final Color boxColor;
  final Color flapColor;
  final Color tapeColor;
  final Color laserColor;
  final double flapCloseProgress; // 0.0 = fully open (\ /), 1.0 = fully closed & sealed (_)
  final double labelProgress; // 0.0 = no label, 1.0 = white shipping label stamped
  final double laserProgress; // 0.0 -> 1.0 scanning animation
  final bool isScanning;
  final double scannerY; // Bottom of overhead scanner unit to anchor laser beam

  const FactoryBoxPainter({
    required this.boxColor,
    required this.flapColor,
    required this.tapeColor,
    required this.laserColor,
    required this.flapCloseProgress,
    required this.labelProgress,
    required this.laserProgress,
    required this.isScanning,
    this.scannerY = 19.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Red Laser Scanner Beam (if scanning)
    if (isScanning && laserProgress > 0.01) {
      final beamCenterX = w / 2;
      final scanWidth = w * 0.7;
      final scanTop = scannerY;
      final scanBottom = h;

      // Laser fan / cone from scanner
      final laserPath = Path()
        ..moveTo(beamCenterX - 3, scanTop)
        ..lineTo(beamCenterX + 3, scanTop)
        ..lineTo(beamCenterX + (scanWidth / 2) * laserProgress, scanBottom)
        ..lineTo(beamCenterX - (scanWidth / 2) * laserProgress, scanBottom)
        ..close();

      final laserGlowPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            laserColor.withValues(alpha: 0.55),
            laserColor.withValues(alpha: 0.15),
            laserColor.withValues(alpha: 0.0),
          ],
        ).createShader(Rect.fromLTRB(beamCenterX - scanWidth, scanTop, beamCenterX + scanWidth, scanBottom))
        ..style = PaintingStyle.fill;
      canvas.drawPath(laserPath, laserGlowPaint);

      // Central focused laser line
      final laserLinePaint = Paint()
        ..color = laserColor.withValues(alpha: 0.85)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(beamCenterX, scanTop),
        Offset(beamCenterX, scanBottom),
        laserLinePaint,
      );
    }

    // 2. Open / Closed Cardboard Flaps (Top)
    final boxBodyTop = h * 0.28;
    final boxBodyHeight = h * 0.72;
    final flapWidth = w * 0.44;
    final flapHeight = h * 0.28;

    final flapPaint = Paint()
      ..color = flapColor
      ..style = PaintingStyle.fill;

    final flapStrokePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Left Flap: rotates from -55 degrees to 0 degrees
    final leftAngle = -55.0 * (1.0 - flapCloseProgress) * (math.pi / 180.0);
    canvas.save();
    canvas.translate(2.0, boxBodyTop);
    canvas.rotate(leftAngle);
    final leftFlapRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, -flapHeight, flapWidth, flapHeight),
      const Radius.circular(2.0),
    );
    canvas.drawRRect(leftFlapRect, flapPaint);
    canvas.drawRRect(leftFlapRect, flapStrokePaint);
    canvas.restore();

    // Right Flap: rotates from +55 degrees to 0 degrees
    final rightAngle = 55.0 * (1.0 - flapCloseProgress) * (math.pi / 180.0);
    canvas.save();
    canvas.translate(w - 2.0, boxBodyTop);
    canvas.rotate(rightAngle);
    final rightFlapRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-flapWidth, -flapHeight, flapWidth, flapHeight),
      const Radius.circular(2.0),
    );
    canvas.drawRRect(rightFlapRect, flapPaint);
    canvas.drawRRect(rightFlapRect, flapStrokePaint);
    canvas.restore();

    // 3. Cardboard Box Body
    final boxRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, boxBodyTop, w, boxBodyHeight),
      const Radius.circular(3.5),
    );

    final boxPaint = Paint()
      ..color = boxColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(boxRect, boxPaint);

    // Subtle edge shading for depth
    final boxOutlinePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(boxRect, boxOutlinePaint);

    // 4. Sealing Tape Strip (Appears as flaps close)
    if (flapCloseProgress > 0.6) {
      final tapeOpacity = ((flapCloseProgress - 0.6) / 0.4).clamp(0.0, 1.0);
      final tapePaint = Paint()
        ..color = tapeColor.withValues(alpha: tapeOpacity)
        ..style = PaintingStyle.fill;
      final tapeRect = Rect.fromLTWH(w * 0.35, boxBodyTop - 1, w * 0.30, boxBodyHeight * 0.45);
      canvas.drawRect(tapeRect, tapePaint);
    }

    // 5. Barcode on Front Face
    final barcodeLeft = 4.0;
    final barcodeTop = boxBodyTop + boxBodyHeight * 0.35;
    final barcodeHeight = boxBodyHeight * 0.45;

    final barcodePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    final barWidths = [1.2, 0.8, 1.5, 0.8, 1.2];
    double currentBarX = barcodeLeft;
    for (final bWidth in barWidths) {
      barcodePaint.strokeWidth = bWidth;
      canvas.drawLine(
        Offset(currentBarX, barcodeTop),
        Offset(currentBarX, barcodeTop + barcodeHeight),
        barcodePaint,
      );
      currentBarX += bWidth + 1.2;
    }

    // 6. Stamped Shipping Label (White with small address stripes)
    if (labelProgress > 0.05) {
      final labelOpacity = labelProgress.clamp(0.0, 1.0);
      final labelWidth = (w * 0.42) * labelProgress;
      final labelHeight = (boxBodyHeight * 0.55) * labelProgress;
      final labelLeft = w - labelWidth - 3.5;
      final labelTop = boxBodyTop + (boxBodyHeight - labelHeight) / 2;

      final labelPaint = Paint()
        ..color = Colors.white.withValues(alpha: labelOpacity)
        ..style = PaintingStyle.fill;

      final labelRRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(labelLeft, labelTop, labelWidth, labelHeight),
        const Radius.circular(1.5),
      );
      canvas.drawRRect(labelRRect, labelPaint);

      // Mini text lines on the label
      if (labelProgress > 0.7) {
        final linePaint = Paint()
          ..color = const Color(0xFF64748B).withValues(alpha: labelOpacity * 0.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9;

        final lineLeft = labelLeft + 2.0;
        final lineRight = labelLeft + labelWidth - 2.0;
        final lineY1 = labelTop + labelHeight * 0.32;
        final lineY2 = labelTop + labelHeight * 0.62;

        if (lineRight > lineLeft) {
          canvas.drawLine(Offset(lineLeft, lineY1), Offset(lineRight, lineY1), linePaint);
          canvas.drawLine(Offset(lineLeft, lineY2), Offset(lineLeft + (lineRight - lineLeft) * 0.65, lineY2), linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant FactoryBoxPainter oldDelegate) {
    return oldDelegate.flapCloseProgress != flapCloseProgress ||
        oldDelegate.labelProgress != labelProgress ||
        oldDelegate.laserProgress != laserProgress ||
        oldDelegate.isScanning != isScanning ||
        oldDelegate.boxColor != boxColor ||
        oldDelegate.laserColor != laserColor;
  }
}
