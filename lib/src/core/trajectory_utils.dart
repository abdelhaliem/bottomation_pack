import 'dart:ui';

/// Utility methods for trajectory paths, quadratic & cubic Bézier interpolation.
class TrajectoryUtils {
  const TrajectoryUtils._();

  /// Calculates a point on a quadratic Bézier curve at parameter [t] in [0.0, 1.0].
  ///
  /// [p0]: Starting point.
  /// [p1]: Control point (peak of the arc).
  /// [p2]: Target destination point.
  static Offset quadraticBezier(Offset p0, Offset p1, Offset p2, double t) {
    final double clampedT = t.clamp(0.0, 1.0);
    final double u = 1.0 - clampedT;
    final double tt = clampedT * clampedT;
    final double uu = u * u;

    final double x = (uu * p0.dx) + (2 * u * clampedT * p1.dx) + (tt * p2.dx);
    final double y = (uu * p0.dy) + (2 * u * clampedT * p1.dy) + (tt * p2.dy);

    return Offset(x, y);
  }
}
