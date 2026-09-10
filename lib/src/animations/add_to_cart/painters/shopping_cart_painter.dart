import 'package:flutter/material.dart';

/// Paints the wireframe shopping cart, wheels, landing suspension bounce,
/// and the animated "+1" popping notification badge.
class ShoppingCartPainter extends CustomPainter {
  final Color cartColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final double cartEntranceProgress; // 0.0 = offscreen/faded, 1.0 = in place
  final double bounceProgress; // 0.0 -> 1.0 spring bounce when box lands
  final double badgeProgress; // 0.0 = hidden, 1.0 = popped up with bounce
  final bool isRtl;

  const ShoppingCartPainter({
    required this.cartColor,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.cartEntranceProgress,
    required this.bounceProgress,
    required this.badgeProgress,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (cartEntranceProgress <= 0.01) return;

    final w = size.width;
    final h = size.height;
    final opacity = cartEntranceProgress.clamp(0.0, 1.0);

    // Suspension bounce vertical displacement: dips downward then springs back
    // sin(bounceProgress * pi) produces a nice physical dip
    final bounceDip = (bounceProgress > 0.0 && bounceProgress < 1.0)
        ? (2.5 * (1.0 - bounceProgress) * (1.0 - bounceProgress))
        : 0.0;

    canvas.save();
    canvas.translate(0, bounceDip);

    // 1. Shopping Cart Wireframe
    final cartPaint = Paint()
      ..color = cartColor.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final basketTop = h * 0.28;
    final basketBottom = h * 0.72;
    final wheelY = h * 0.88;
    final wheelRadius = 3.0;

    if (!isRtl) {
      // LTR: Handle is on the left, basket opens to the right
      final handleStart = Offset(w * 0.06, basketTop - 4);
      final handleBend = Offset(w * 0.20, basketTop + 2);
      final basketBottomLeft = Offset(w * 0.28, basketBottom);
      final basketBottomRight = Offset(w * 0.88, basketBottom);
      final basketTopRight = Offset(w * 0.98, basketTop);

      // Handle & Cart basket path
      final cartPath = Path()
        ..moveTo(handleStart.dx, handleStart.dy)
        ..lineTo(handleBend.dx, handleBend.dy)
        ..lineTo(basketBottomLeft.dx, basketBottomLeft.dy)
        ..lineTo(basketBottomRight.dx, basketBottomRight.dy)
        ..lineTo(basketTopRight.dx, basketTopRight.dy)
        ..lineTo(handleBend.dx, basketTop);
      canvas.drawPath(cartPath, cartPaint);

      // Left wheel & Right wheel
      final wheelPaint = Paint()
        ..color = cartColor.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(Offset(w * 0.36, wheelY), wheelRadius, wheelPaint);
      canvas.drawCircle(Offset(w * 0.78, wheelY), wheelRadius, wheelPaint);
    } else {
      // RTL: Handle is on the right, basket opens to the left
      final handleStart = Offset(w * 0.94, basketTop - 4);
      final handleBend = Offset(w * 0.80, basketTop + 2);
      final basketBottomRight = Offset(w * 0.72, basketBottom);
      final basketBottomLeft = Offset(w * 0.12, basketBottom);
      final basketTopLeft = Offset(w * 0.02, basketTop);

      final cartPath = Path()
        ..moveTo(handleStart.dx, handleStart.dy)
        ..lineTo(handleBend.dx, handleBend.dy)
        ..lineTo(basketBottomRight.dx, basketBottomRight.dy)
        ..lineTo(basketBottomLeft.dx, basketBottomLeft.dy)
        ..lineTo(basketTopLeft.dx, basketTopLeft.dy)
        ..lineTo(handleBend.dx, basketTop);
      canvas.drawPath(cartPath, cartPaint);

      final wheelPaint = Paint()
        ..color = cartColor.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      canvas.drawCircle(Offset(w * 0.64, wheelY), wheelRadius, wheelPaint);
      canvas.drawCircle(Offset(w * 0.22, wheelY), wheelRadius, wheelPaint);
    }

    canvas.restore(); // Restore bounce displacement

    // 2. "+1" Popping Badge (Floating above cart with spring scale)
    if (badgeProgress > 0.01) {
      final badgeOpacity = badgeProgress.clamp(0.0, 1.0);
      final badgeScale = badgeProgress;

      final badgeCenterX = isRtl ? (w * 0.25) : (w * 0.75);
      // Floats upwards as it animates
      final badgeCenterY = (basketTop - 12.0) - (badgeProgress * 4.0);

      canvas.save();
      canvas.translate(badgeCenterX, badgeCenterY);
      canvas.scale(badgeScale);

      // Glow behind badge
      final badgeGlowPaint = Paint()
        ..color = badgeColor.withValues(alpha: 0.45 * badgeOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);
      canvas.drawCircle(Offset.zero, 11.0, badgeGlowPaint);

      // Badge pill background
      const badgeW = 26.0;
      const badgeH = 17.0;
      final badgeRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: badgeW, height: badgeH),
        const Radius.circular(8.5),
      );
      final badgeFillPaint = Paint()
        ..color = badgeColor.withValues(alpha: badgeOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(badgeRect, badgeFillPaint);

      // Text "+1"
      final textSpan = TextSpan(
        text: '+1',
        style: TextStyle(
          color: badgeTextColor.withValues(alpha: badgeOpacity),
          fontSize: 11.5,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.2,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant ShoppingCartPainter oldDelegate) {
    return oldDelegate.cartEntranceProgress != cartEntranceProgress ||
        oldDelegate.bounceProgress != bounceProgress ||
        oldDelegate.badgeProgress != badgeProgress ||
        oldDelegate.cartColor != cartColor ||
        oldDelegate.badgeColor != badgeColor;
  }
}
