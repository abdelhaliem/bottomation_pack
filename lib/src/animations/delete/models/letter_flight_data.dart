import 'dart:ui';

/// Stores animation trajectory and timing data for an individual letter during suction.
class LetterFlightData {
  /// The individual character being animated.
  final String char;

  /// Original layout position of the letter in the button.
  final Offset startPosition;

  /// Peak control point of the Bézier flight trajectory.
  final Offset controlPoint;

  /// Target landing position inside the trash bin opening.
  final Offset targetPosition;

  /// Normalized delay offset [0.0 - 1.0] when this letter begins its flight.
  final double startDelay;

  /// Duration fraction of the flight [0.0 - 1.0] relative to total letter flight phase.
  final double flightDuration;

  /// Total rotation in radians the letter experiences during flight.
  final double targetRotation;

  const LetterFlightData({
    required this.char,
    required this.startPosition,
    required this.controlPoint,
    required this.targetPosition,
    required this.startDelay,
    this.flightDuration = 0.55,
    this.targetRotation = -1.2,
  });
}
