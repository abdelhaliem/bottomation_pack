import 'package:flutter/material.dart';

/// Custom painter for rendering the top-down cardboard shipping package.
class OrderPackagePainter extends CustomPainter {
  final Color packageColor;
  final Color tapeColor;
  final double size;

  const OrderPackagePainter({
    required this.packageColor,
    required this.tapeColor,
    this.size = 18.0,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final rect = Rect.fromCenter(center: center, width: size, height: size);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2.5));

    // Subtle drop shadow under the package
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawRRect(rrect.shift(const Offset(0, 1.5)), shadowPaint);

    // Box body
    final boxPaint = Paint()
      ..color = packageColor
      ..style = PaintingStyle.fill;
    canvas.drawRRect(rrect, boxPaint);

    // Center sealing tape
    final tapePaint = Paint()
      ..color = tapeColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    // Horizontal center tape
    canvas.drawLine(
      Offset(rect.left, center.dy),
      Offset(rect.right, center.dy),
      tapePaint,
    );

    // Subtle cardboard edge outline
    final outlinePaint = Paint()
      ..color = tapeColor.withValues(alpha: 0.5)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(rrect, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant OrderPackagePainter oldDelegate) {
    return oldDelegate.packageColor != packageColor ||
        oldDelegate.tapeColor != tapeColor ||
        oldDelegate.size != size;
  }
}
