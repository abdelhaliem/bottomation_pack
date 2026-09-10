import 'package:flutter/material.dart';

/// Paints the animated trash bin icon with an independently rotating hinge lid
/// and support for outline or filled drawing styles.
class TrashBinPainter extends CustomPainter {
  /// Color used for strokes or fills.
  final Color color;

  /// Angle in radians to tilt the lid open (0.0 = closed, ~ -0.7 = fully open).
  final double lidAngle;

  /// Whether to render as a solid filled icon (used during the circular loading state)
  /// or as a sleek outlined stroke (used in idle state).
  final bool isFilled;

  /// Stroke width when [isFilled] is false.
  final double strokeWidth;

  /// Whether the layout is Right-to-Left (mirrors the lid hinge).
  final bool isRtl;

  TrashBinPainter({
    required this.color,
    this.lidAngle = 0.0,
    this.isFilled = false,
    this.strokeWidth = 2.2,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint paint = Paint()
      ..color = color
      ..style = isFilled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Dimensions for the bin
    final double binTop = height * 0.32;
    final double binBottom = height * 0.92;
    final double binLeft = width * 0.22;
    final double binRight = width * 0.78;
    final double binBottomLeft = width * 0.27;
    final double binBottomRight = width * 0.73;
    final double cornerRadius = width * 0.08;

    // 1. Draw Bin Body
    final Path bodyPath = Path();
    bodyPath.moveTo(binLeft, binTop);
    bodyPath.lineTo(binBottomLeft + cornerRadius, binBottom);
    bodyPath.quadraticBezierTo(
      binBottomLeft,
      binBottom,
      binBottomLeft + cornerRadius,
      binBottom,
    );
    bodyPath.lineTo(binBottomRight - cornerRadius, binBottom);
    bodyPath.quadraticBezierTo(
      binBottomRight,
      binBottom,
      binBottomRight - (cornerRadius * 0.5),
      binBottom - cornerRadius,
    );
    bodyPath.lineTo(binRight, binTop);

    if (isFilled) {
      bodyPath.close();
      canvas.drawPath(bodyPath, paint);
    } else {
      canvas.drawPath(bodyPath, paint);

      // Draw subtle inner vertical rib lines when outlined
      final Paint ribPaint = Paint()
        ..color = color.withValues(alpha: 0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * 0.75
        ..strokeCap = StrokeCap.round;

      final double centerX = width * 0.5;
      final double spacing = width * 0.12;

      // Left rib
      canvas.drawLine(
        Offset(centerX - spacing, binTop + height * 0.12),
        Offset(centerX - spacing * 0.85, binBottom - height * 0.12),
        ribPaint,
      );
      // Right rib
      canvas.drawLine(
        Offset(centerX + spacing, binTop + height * 0.12),
        Offset(centerX + spacing * 0.85, binBottom - height * 0.12),
        ribPaint,
      );
    }

    // 2. Draw Bin Lid (Rotates around hinge anchor)
    final double hingeX = isRtl ? width * 0.84 : width * 0.16;
    final double hingeY = binTop;

    canvas.save();
    canvas.translate(hingeX, hingeY);
    // In RTL, the hinge is on the right, so a positive rotation tilts the lid open to the left.
    final double effectiveAngle = isRtl ? -lidAngle : lidAngle;
    canvas.rotate(effectiveAngle);
    canvas.translate(-hingeX, -hingeY);

    // Rim of the lid
    final double rimLeft = width * 0.14;
    final double rimRight = width * 0.86;
    final double rimY = binTop;

    final Paint lidPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(rimLeft, rimY), Offset(rimRight, rimY), lidPaint);

    // Lid top handle / cap
    final double handleLeft = width * 0.38;
    final double handleRight = width * 0.62;
    final double handleTop = height * 0.18;
    final double handleRadius = width * 0.05;

    final Path handlePath = Path();
    handlePath.moveTo(handleLeft, rimY);
    handlePath.lineTo(handleLeft, handleTop + handleRadius);
    handlePath.arcToPoint(
      Offset(handleLeft + handleRadius, handleTop),
      radius: Radius.circular(handleRadius),
    );
    handlePath.lineTo(handleRight - handleRadius, handleTop);
    handlePath.arcToPoint(
      Offset(handleRight, handleTop + handleRadius),
      radius: Radius.circular(handleRadius),
    );
    handlePath.lineTo(handleRight, rimY);

    if (isFilled) {
      final Paint fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      canvas.drawPath(handlePath, fillPaint);
      // Fill lid slab
      final RRect lidRect = RRect.fromRectAndRadius(
        Rect.fromLTRB(rimLeft, rimY - height * 0.06, rimRight, rimY + height * 0.02),
        Radius.circular(height * 0.02),
      );
      canvas.drawRRect(lidRect, fillPaint);
    } else {
      canvas.drawPath(handlePath, lidPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TrashBinPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.lidAngle != lidAngle ||
        oldDelegate.isFilled != isFilled ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.isRtl != isRtl;
  }
}
