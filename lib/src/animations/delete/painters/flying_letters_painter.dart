import 'package:flutter/material.dart';
import '../../../core/trajectory_utils.dart';
import '../models/letter_flight_data.dart';

/// Paints individual text letters along dynamic Bézier flight trajectories
/// as they scatter and get sucked into the trash can.
class FlyingLettersPainter extends CustomPainter {
  /// The collection of letters with their individual flight paths and timings.
  final List<LetterFlightData> letters;

  /// Overall suction animation progress from 0.0 to 1.0.
  final double animationProgress;

  /// Text style for rendering the letters.
  final TextStyle textStyle;

  /// Text direction for rendering the characters (LTR or RTL).
  final TextDirection textDirection;

  FlyingLettersPainter({
    required this.letters,
    required this.animationProgress,
    required this.textStyle,
    this.textDirection = TextDirection.ltr,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (letters.isEmpty) return;

    for (final letter in letters) {
      final double progress = animationProgress;

      if (progress < letter.startDelay) {
        // Not yet started flying - draw at original position
        _drawLetter(
          canvas,
          letter.char,
          letter.startPosition,
          rotation: 0.0,
          scale: 1.0,
          opacity: 1.0,
        );
      } else {
        final double t = (progress - letter.startDelay) / letter.flightDuration;

        if (t >= 1.0) {
          // Already completely fallen into the bin - invisible
          continue;
        }

        final double curvedT = Curves.easeInOutQuad.transform(t);

        // Position along quadratic Bézier curve
        final Offset currentPos = TrajectoryUtils.quadraticBezier(
          letter.startPosition,
          letter.controlPoint,
          letter.targetPosition,
          curvedT,
        );

        // Rotation increases as the letter flies
        final double rotation = curvedT * letter.targetRotation;

        // Shrink progressively as it enters the bin
        final double scale = (1.0 - (curvedT * 0.65)).clamp(0.1, 1.0);

        // Opacity drops as it reaches the mouth of the bin
        final double opacity = (1.0 - (curvedT > 0.8 ? (curvedT - 0.8) / 0.2 : 0.0))
            .clamp(0.0, 1.0);

        _drawLetter(
          canvas,
          letter.char,
          currentPos,
          rotation: rotation,
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
    required double rotation,
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
    if (rotation != 0.0) {
      canvas.rotate(rotation);
    }
    if (scale != 1.0) {
      canvas.scale(scale);
    }
    // Center the character around its anchor
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant FlyingLettersPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.letters != letters ||
        oldDelegate.textDirection != textDirection;
  }
}
