import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints an architectural arched door with frame, interior threshold glow, and a 3D perspective
/// swinging door leaf that opens to let text exit.
///
/// Features a slender silhouette and rounded top-left and top-right corners with flat ground corners.
class DoorExitPainter extends CustomPainter {
  /// Primary color for the door and frame.
  final Color color;

  /// Interior glow or doorway light when the door is open.
  final Color? glowColor;

  /// Open progress of the door [0.0 = fully closed, 1.0 = fully open].
  final double doorOpenProgress;

  /// Whether the door is rendered for Right-to-Left layout (mirrors the hinge).
  final bool isRtl;

  /// Stroke width for frame and lines.
  final double strokeWidth;

  DoorExitPainter({
    required this.color,
    this.glowColor,
    required this.doorOpenProgress,
    this.isRtl = false,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Slender door proportions
    final double frameLeft = width * 0.10;
    final double frameRight = width * 0.90;
    final double frameTop = height * 0.08;
    final double frameBottom = height * 0.92;
    final double doorwayWidth = frameRight - frameLeft;
    final double doorwayHeight = frameBottom - frameTop;

    // Radius for the rounded top corners (semi-arched header)
    final double topRadius = doorwayWidth * 0.38;

    final double progress = doorOpenProgress.clamp(0.0, 1.0);

    // 1. Interior Doorway Glow (Visible when door opens)
    if (progress > 0.05) {
      final double glowOpacity = (progress * 0.65).clamp(0.0, 0.65);
      final Paint glowPaint = Paint()
        ..color = (glowColor ?? Colors.white).withValues(alpha: glowOpacity)
        ..style = PaintingStyle.fill;

      final RRect doorwayRRect = RRect.fromRectAndCorners(
        Rect.fromLTRB(
          frameLeft + strokeWidth / 2,
          frameTop + strokeWidth / 2,
          frameRight - strokeWidth / 2,
          frameBottom,
        ),
        topLeft: Radius.circular(topRadius),
        topRight: Radius.circular(topRadius),
        bottomLeft: Radius.zero,
        bottomRight: Radius.zero,
      );
      canvas.drawRRect(doorwayRRect, glowPaint);
    }

    // 2. Fixed Outer Door Frame with Rounded Top Corners
    final Paint framePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final Path framePath = Path();
    // Bottom-left corner (straight) -> up to top-left radius -> arch -> top-right radius -> down to bottom-right
    framePath.moveTo(frameLeft, frameBottom);
    framePath.lineTo(frameLeft, frameTop + topRadius);
    framePath.arcToPoint(
      Offset(frameLeft + topRadius, frameTop),
      radius: Radius.circular(topRadius),
    );
    framePath.lineTo(frameRight - topRadius, frameTop);
    framePath.arcToPoint(
      Offset(frameRight, frameTop + topRadius),
      radius: Radius.circular(topRadius),
    );
    framePath.lineTo(frameRight, frameBottom);
    canvas.drawPath(framePath, framePaint);

    // Bottom threshold sill line
    final Paint sillPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.85
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(frameLeft - width * 0.08, frameBottom),
      Offset(frameRight + width * 0.08, frameBottom),
      sillPaint,
    );

    // 3. Swinging Door Leaf with Rounded Top in 3D Perspective
    final double swingAngle = progress * (math.pi * 0.40); // Max ~72 degrees
    final double cosVal = math.cos(swingAngle);
    final double sinVal = math.sin(swingAngle);

    final double doorWidth = doorwayWidth - strokeWidth;
    final double doorHeight = doorwayHeight - (strokeWidth / 2);
    final double leafTopRadius = topRadius * 0.88;

    final Paint doorPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Paint doorEdgePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    if (!isRtl) {
      // LTR: Hinge on Left, Door swings open towards the left
      final double hingeX = frameLeft + (strokeWidth / 2);
      final double hingeTopY = frameTop + strokeWidth;
      final double hingeBottomY = frameBottom;

      final double projectedWidth = doorWidth * cosVal;
      final double perspectiveInset = sinVal * doorHeight * 0.12;

      final double edgeX = hingeX + projectedWidth;
      final double edgeTopY = hingeTopY + perspectiveInset;
      final double edgeBottomY = hingeBottomY - perspectiveInset;

      final Path leafPath = Path();
      // Start bottom-left (hinge base)
      leafPath.moveTo(hingeX, hingeBottomY);
      // Up to top-left rounded corner
      leafPath.lineTo(hingeX, hingeTopY + leafTopRadius);
      leafPath.arcToPoint(
        Offset(hingeX + (leafTopRadius * cosVal), hingeTopY),
        radius: Radius.circular(leafTopRadius),
      );
      // Across arched header towards swinging edge
      leafPath.lineTo(edgeX - (leafTopRadius * cosVal * 0.4), edgeTopY);
      leafPath.arcToPoint(
        Offset(edgeX, edgeTopY + leafTopRadius),
        radius: Radius.circular(leafTopRadius),
      );
      // Down to bottom-right edge
      leafPath.lineTo(edgeX, edgeBottomY);
      // Bottom flat edge back to hinge base
      leafPath.lineTo(hingeX, hingeBottomY);
      leafPath.close();

      final double shadeAlpha = (0.92 - (progress * 0.25)).clamp(0.4, 0.95);
      doorPaint.color = color.withValues(alpha: shadeAlpha);
      canvas.drawPath(leafPath, doorPaint);
      canvas.drawPath(leafPath, doorEdgePaint);

      // Sleek door handle / knob
      if (cosVal > 0.15) {
        final double knobX = edgeX - (projectedWidth * 0.16);
        final double knobY = hingeTopY + (doorHeight * 0.54);
        final Paint knobPaint = Paint()
          ..color = (color == Colors.white ? const Color(0xFF1E2128) : Colors.white)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(knobX, knobY), width * 0.05 * cosVal, knobPaint);
      }
    } else {
      // RTL: Hinge on Right, Door swings open towards the right
      final double hingeX = frameRight - (strokeWidth / 2);
      final double hingeTopY = frameTop + strokeWidth;
      final double hingeBottomY = frameBottom;

      final double projectedWidth = doorWidth * cosVal;
      final double perspectiveInset = sinVal * doorHeight * 0.12;

      final double edgeX = hingeX - projectedWidth;
      final double edgeTopY = hingeTopY + perspectiveInset;
      final double edgeBottomY = hingeBottomY - perspectiveInset;

      final Path leafPath = Path();
      // Start bottom-right (hinge base)
      leafPath.moveTo(hingeX, hingeBottomY);
      // Up to top-right rounded corner
      leafPath.lineTo(hingeX, hingeTopY + leafTopRadius);
      leafPath.arcToPoint(
        Offset(hingeX - (leafTopRadius * cosVal), hingeTopY),
        radius: Radius.circular(leafTopRadius),
        clockwise: false,
      );
      // Across header to top-left corner
      leafPath.lineTo(edgeX + (leafTopRadius * cosVal * 0.4), edgeTopY);
      leafPath.arcToPoint(
        Offset(edgeX, edgeTopY + leafTopRadius),
        radius: Radius.circular(leafTopRadius),
        clockwise: false,
      );
      // Down to bottom-left edge
      leafPath.lineTo(edgeX, edgeBottomY);
      // Flat bottom edge back to hinge base
      leafPath.lineTo(hingeX, hingeBottomY);
      leafPath.close();

      final double shadeAlpha = (0.92 - (progress * 0.25)).clamp(0.4, 0.95);
      doorPaint.color = color.withValues(alpha: shadeAlpha);
      canvas.drawPath(leafPath, doorPaint);
      canvas.drawPath(leafPath, doorEdgePaint);

      // Sleek door handle / knob
      if (cosVal > 0.15) {
        final double knobX = edgeX + (projectedWidth * 0.16);
        final double knobY = hingeTopY + (doorHeight * 0.54);
        final Paint knobPaint = Paint()
          ..color = (color == Colors.white ? const Color(0xFF1E2128) : Colors.white)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(knobX, knobY), width * 0.05 * cosVal, knobPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DoorExitPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.doorOpenProgress != doorOpenProgress ||
        oldDelegate.isRtl != isRtl ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
