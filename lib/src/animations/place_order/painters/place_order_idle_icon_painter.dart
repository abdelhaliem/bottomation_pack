import 'package:flutter/material.dart';

/// Painter for rendering a top-down or sleek profile delivery truck icon in the idle state.
class PlaceOrderIdleIconPainter extends CustomPainter {
  final Color truckColor;
  final Color cargoColor;
  final bool isRtl;

  const PlaceOrderIdleIconPainter({
    required this.truckColor,
    required this.cargoColor,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    if (isRtl) {
      canvas.scale(-1.0, 1.0);
    }

    const totalWidth = 24.0;
    const totalHeight = 14.0;
    const halfH = totalHeight / 2;
    const cargoW = 15.0;
    const left = -totalWidth / 2;
    const cargoRight = left + cargoW;
    const right = left + totalWidth;

    // Cargo box
    final cargoRect = Rect.fromLTRB(left, -halfH, cargoRight, halfH);
    final cargoPaint = Paint()
      ..color = cargoColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(cargoRect, const Radius.circular(1.5)),
      cargoPaint,
    );

    // Cab
    final cabRect = Rect.fromLTRB(cargoRight, -halfH + 1.0, right, halfH - 1.0);
    final cabPaint = Paint()
      ..color = truckColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        cabRect,
        topRight: const Radius.circular(4.0),
        bottomRight: const Radius.circular(4.0),
      ),
      cabPaint,
    );

    // Windshield
    final windshieldRect = Rect.fromLTRB(
      cargoRight + 2.0,
      -halfH + 2.0,
      cargoRight + 5.0,
      halfH - 2.0,
    );
    final windshieldPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(windshieldRect, const Radius.circular(1.0)),
      windshieldPaint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant PlaceOrderIdleIconPainter oldDelegate) {
    return oldDelegate.truckColor != truckColor ||
        oldDelegate.cargoColor != cargoColor ||
        oldDelegate.isRtl != isRtl;
  }
}
