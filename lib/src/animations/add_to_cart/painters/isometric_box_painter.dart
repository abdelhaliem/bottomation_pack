import 'package:flutter/material.dart';

/// Paints an isometric 3D wireframe cube icon for the idle state of [Bottomation.addToCart].
class IsometricBoxPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  const IsometricBoxPainter({
    required this.color,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    // Geometric isometric cube points:
    final topCenter = Offset(w * 0.5, h * 0.12);
    final topR = Offset(w * 0.88, h * 0.34);
    final bottomCenter = Offset(w * 0.5, h * 0.56);
    final topL = Offset(w * 0.12, h * 0.34);

    final bottomL = Offset(w * 0.12, h * 0.72);
    final bottomMid = Offset(w * 0.5, h * 0.94);
    final bottomR = Offset(w * 0.88, h * 0.72);

    // Top diamond face
    final topFace = Path()
      ..moveTo(topCenter.dx, topCenter.dy)
      ..lineTo(topR.dx, topR.dy)
      ..lineTo(bottomCenter.dx, bottomCenter.dy)
      ..lineTo(topL.dx, topL.dy)
      ..close();
    canvas.drawPath(topFace, paint);

    // Left face outline
    final leftFace = Path()
      ..moveTo(topL.dx, topL.dy)
      ..lineTo(bottomL.dx, bottomL.dy)
      ..lineTo(bottomMid.dx, bottomMid.dy)
      ..lineTo(bottomCenter.dx, bottomCenter.dy);
    canvas.drawPath(leftFace, paint);

    // Right face outline
    final rightFace = Path()
      ..moveTo(topR.dx, topR.dy)
      ..lineTo(bottomR.dx, bottomR.dy)
      ..lineTo(bottomMid.dx, bottomMid.dy);
    canvas.drawPath(rightFace, paint);
  }

  @override
  bool shouldRepaint(covariant IsometricBoxPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}
