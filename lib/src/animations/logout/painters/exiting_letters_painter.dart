import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/logout_letter_exit_data.dart';

/// Paints individual text letters moving towards the doorway and stepping inside.
class ExitingLettersPainter extends CustomPainter {
  /// The collection of letters with exit paths and timings.
  final List<LogoutLetterExitData> letters;

  /// Overall exit progress from 0.0 to 1.0.
  final double animationProgress;

  /// Text style for the letters.
  final TextStyle textStyle;

  /// Text direction for character layout.
  final TextDirection textDirection;

  /// Whether the layout is RTL.
  final bool isRtl;

  ExitingLettersPainter({
    required this.letters,
    required this.animationProgress,
    required this.textStyle,
    this.textDirection = TextDirection.ltr,
    this.isRtl = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (letters.isEmpty) return;

    for (final letter in letters) {
      final double progress = animationProgress;

      if (progress < letter.startDelay) {
        // Has not started walking yet: render at rest
        _drawLetter(
          canvas,
          letter.char,
          letter.startPosition,
          scale: 1.0,
          opacity: 1.0,
        );
      } else {
        final double t = (progress - letter.startDelay) / letter.exitDuration;

        if (t >= 1.0) {
          // Already completely walked through the door
          continue;
        }

        final double curvedT = Curves.easeInOutCubic.transform(t);

        // Linear interpolation towards doorway
        final double curX = letter.startPosition.dx +
            (letter.exitDestination.dx - letter.startPosition.dx) * curvedT;

        // Subtle walking bob rhythm
        final double bobY = -math.sin(curvedT * math.pi * 3.0).abs() * 3.5;
        final double curY = letter.startPosition.dy + bobY;

        // When crossing the doorway threshold, decrease scale and opacity
        double scale = 1.0;
        double opacity = 1.0;

        final bool crossedThreshold = isRtl
            ? curX >= letter.doorwayThresholdX
            : curX <= letter.doorwayThresholdX;

        if (crossedThreshold) {
          // Inside the doorway: shrink and fade as if stepping into the distance
          final double distancePastThreshold = isRtl
              ? (curX - letter.doorwayThresholdX) / 25.0
              : (letter.doorwayThresholdX - curX) / 25.0;

          final double entryRatio = distancePastThreshold.clamp(0.0, 1.0);
          scale = (1.0 - (entryRatio * 0.45)).clamp(0.1, 1.0);
          opacity = (1.0 - (entryRatio * 0.95)).clamp(0.0, 1.0);
        }

        _drawLetter(
          canvas,
          letter.char,
          Offset(curX, curY),
          scale: scale,
          opacity: opacity,
        );
      }
    }
  }

  void _drawLetter(
    Canvas canvas,
    String char,
    Offset position, {
    required double scale,
    required double opacity,
  }) {
    if (opacity <= 0.01) return;

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: char,
        style: textStyle.copyWith(
          color: (textStyle.color ?? Colors.white).withValues(alpha: opacity),
        ),
      ),
      textDirection: textDirection,
    )..layout();

    canvas.save();
    canvas.translate(position.dx, position.dy);
    if (scale != 1.0) {
      canvas.scale(scale);
    }
    // Center character around position
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ExitingLettersPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.letters != letters ||
        oldDelegate.textDirection != textDirection ||
        oldDelegate.isRtl != isRtl;
  }
}
