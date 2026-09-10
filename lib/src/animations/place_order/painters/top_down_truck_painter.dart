import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Custom painter for rendering the top-down delivery truck,
/// its articulating rear cargo doors, headlights, and illuminated light cones.
class TopDownTruckPainter extends CustomPainter {
  final Color truckColor;
  final Color cargoColor;
  final Color windshieldColor;
  final Color headlightColor;
  final Color headlightBeamColor;
  final double doorsOpenProgress; // 0.0 (closed) to 1.0 (fully open)
  final double headlightsProgress; // 0.0 (off) to 1.0 (fully illuminated)
  final bool isRtl;

  const TopDownTruckPainter({
    required this.truckColor,
    required this.cargoColor,
    required this.windshieldColor,
    required this.headlightColor,
    required this.headlightBeamColor,
    this.doorsOpenProgress = 0.0,
    this.headlightsProgress = 0.0,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Center coordinates
    canvas.translate(size.width / 2, size.height / 2);

    // If RTL, flip horizontally so truck faces left
    if (isRtl) {
      canvas.scale(-1.0, 1.0);
    }

    const truckTotalWidth = 54.0;
    const truckHeight = 24.0;
    const halfH = truckHeight / 2;
    const cargoLength = 36.0;
    const cabLength = 18.0;
    const cargoLeft = -truckTotalWidth / 2; // -27
    const cargoRight = cargoLeft + cargoLength; // +9
    const cabRight = cargoRight + cabLength; // +27

    // 1. Drop shadow under truck
    final shadowRRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(cargoLeft, -halfH, cabRight, halfH),
      const Radius.circular(4.0),
    );
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
    canvas.drawRRect(shadowRRect.shift(const Offset(0, 2.0)), shadowPaint);

    // 2. Headlight Beams (drawn under or behind truck)
    if (headlightsProgress > 0.0) {
      final beamAlpha = headlightsProgress.clamp(0.0, 1.0);
      final beamPaint = Paint()
        ..color = headlightBeamColor.withValues(
          alpha: (headlightBeamColor.a * beamAlpha).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill;

      const beamReach = 45.0;
      const topBulbY = -halfH + 3.5;
      const bottomBulbY = halfH - 3.5;

      // Top light cone
      final topCone = Path()
        ..moveTo(cabRight - 1.0, topBulbY)
        ..lineTo(cabRight + beamReach, topBulbY - 14.0)
        ..lineTo(cabRight + beamReach, topBulbY + 6.0)
        ..close();
      canvas.drawPath(topCone, beamPaint);

      // Bottom light cone
      final bottomCone = Path()
        ..moveTo(cabRight - 1.0, bottomBulbY)
        ..lineTo(cabRight + beamReach, bottomBulbY - 6.0)
        ..lineTo(cabRight + beamReach, bottomBulbY + 14.0)
        ..close();
      canvas.drawPath(bottomCone, beamPaint);
    }

    // 3. Cargo Container Body
    final cargoRect = Rect.fromLTRB(cargoLeft, -halfH, cargoRight, halfH);
    final cargoRRect = RRect.fromRectAndCorners(
      cargoRect,
      topLeft: const Radius.circular(2.0),
      bottomLeft: const Radius.circular(2.0),
      topRight: Radius.zero,
      bottomRight: Radius.zero,
    );
    final cargoPaint = Paint()
      ..color = cargoColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(cargoRRect, cargoPaint);

    // Cargo subtle border
    final cargoBorderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(cargoRRect, cargoBorderPaint);

    // Cargo center dividing seam
    final seamPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..strokeWidth = 1.0;
    canvas.drawLine(
      Offset((cargoLeft + cargoRight) / 2, -halfH + 2),
      Offset((cargoLeft + cargoRight) / 2, halfH - 2),
      seamPaint,
    );

    // 4. Cab / Driver Cabin
    final cabRect = Rect.fromLTRB(cargoRight, -halfH + 1.0, cabRight, halfH - 1.0);
    final cabRRect = RRect.fromRectAndCorners(
      cabRect,
      topRight: const Radius.circular(7.0),
      bottomRight: const Radius.circular(7.0),
    );
    final cabPaint = Paint()
      ..color = truckColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(cabRRect, cabPaint);

    // Cab border
    final cabBorderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(cabRRect, cabBorderPaint);

    // 5. Windshield
    final windshieldRect = Rect.fromLTRB(
      cargoRight + 4.0,
      -halfH + 3.0,
      cargoRight + 9.5,
      halfH - 3.0,
    );
    final windshieldRRect = RRect.fromRectAndRadius(
      windshieldRect,
      const Radius.circular(2.0),
    );
    final windshieldPaint = Paint()
      ..color = windshieldColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(windshieldRRect, windshieldPaint);

    // Windshield glint reflection
    final glintPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(windshieldRect.left + 1.0, -halfH + 5.0),
      Offset(windshieldRect.right - 1.0, -halfH + 8.5),
      glintPaint,
    );

    // 6. Headlights (amber / bright yellow fixtures on front edge)
    const bulbRadius = 2.0;
    const bulbX = cabRight - 1.5;
    final bulbPaint = Paint()
      ..color = headlightColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(bulbX, -halfH + 3.5), bulbRadius, bulbPaint);
    canvas.drawCircle(Offset(bulbX, halfH - 3.5), bulbRadius, bulbPaint);

    // Cargo interior opening when doors are open
    if (doorsOpenProgress > 0.05) {
      final bedOpenH = (halfH - 2.0) * doorsOpenProgress.clamp(0.0, 1.0);
      final bedRect = Rect.fromLTRB(
        cargoLeft,
        -bedOpenH,
        cargoLeft + 14.0,
        bedOpenH,
      );
      final bedPaint = Paint()
        ..color = Colors.black.withValues(
          alpha: (0.35 * doorsOpenProgress).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.fill;
      canvas.drawRect(bedRect, bedPaint);
    }

    // 7. Articulating Rear Cargo Doors
    // When doorsOpenProgress is 0.0, both doors meet flush at x = cargoLeft, y = 0
    // As doorsOpenProgress increases, they hinge outwards at top and bottom corners up to 130°
    const doorLength = 13.0;
    const maxOpenAngleRad = 130.0 * math.pi / 180.0;
    final currentAngle = maxOpenAngleRad * doorsOpenProgress.clamp(0.0, 1.0);

    final doorPaint = Paint()
      ..color = cargoColor
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final doorEdgePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.18)
      ..strokeWidth = 0.8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Top Door Hinge: (cargoLeft, -halfH + 1.0)
    final topHingeX = cargoLeft;
    final topHingeY = -halfH + 1.0;
    // When closed (angle = 0): points downwards to (cargoLeft, 0)
    // When open (angle > 0): swings outward and backwards (up & back)
    final topDoorEndX = topHingeX - math.sin(currentAngle) * doorLength;
    final topDoorEndY = topHingeY + math.cos(currentAngle) * doorLength;

    canvas.drawLine(
      Offset(topHingeX, topHingeY),
      Offset(topDoorEndX, topDoorEndY),
      doorPaint,
    );
    canvas.drawLine(
      Offset(topHingeX, topHingeY),
      Offset(topDoorEndX, topDoorEndY),
      doorEdgePaint,
    );

    // Bottom Door Hinge: (cargoLeft, halfH - 1.0)
    final bottomHingeX = cargoLeft;
    final bottomHingeY = halfH - 1.0;
    // When closed (angle = 0): points upwards to (cargoLeft, 0)
    // When open (angle > 0): swings outward and backwards (down & back)
    final bottomDoorEndX = bottomHingeX - math.sin(currentAngle) * doorLength;
    final bottomDoorEndY = bottomHingeY - math.cos(currentAngle) * doorLength;

    canvas.drawLine(
      Offset(bottomHingeX, bottomHingeY),
      Offset(bottomDoorEndX, bottomDoorEndY),
      doorPaint,
    );
    canvas.drawLine(
      Offset(bottomHingeX, bottomHingeY),
      Offset(bottomDoorEndX, bottomDoorEndY),
      doorEdgePaint,
    );

    // Hinge pins
    final hingePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(topHingeX, topHingeY), 1.8, hingePaint);
    canvas.drawCircle(Offset(bottomHingeX, bottomHingeY), 1.8, hingePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TopDownTruckPainter oldDelegate) {
    return oldDelegate.truckColor != truckColor ||
        oldDelegate.cargoColor != cargoColor ||
        oldDelegate.windshieldColor != windshieldColor ||
        oldDelegate.headlightColor != headlightColor ||
        oldDelegate.headlightBeamColor != headlightBeamColor ||
        oldDelegate.doorsOpenProgress != doorsOpenProgress ||
        oldDelegate.headlightsProgress != headlightsProgress ||
        oldDelegate.isRtl != isRtl;
  }
}
