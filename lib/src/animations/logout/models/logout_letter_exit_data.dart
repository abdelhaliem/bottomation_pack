import 'dart:ui';

/// Stores animation trajectory and timing data for an individual letter during logout door exit.
class LogoutLetterExitData {
  /// The individual character being animated.
  final String char;

  /// Original layout position of the letter in the button.
  final Offset startPosition;

  /// X-coordinate of the doorway threshold where the letter enters the doorway.
  final double doorwayThresholdX;

  /// Target landing position inside the room past the doorway threshold.
  final Offset exitDestination;

  /// Normalized delay offset [0.0 - 1.0] when this letter begins moving towards the door.
  final double startDelay;

  /// Duration fraction [0.0 - 1.0] of the exit journey.
  final double exitDuration;

  /// Width of this individual character glyph.
  final double charWidth;

  const LogoutLetterExitData({
    required this.char,
    required this.startPosition,
    required this.doorwayThresholdX,
    required this.exitDestination,
    required this.startDelay,
    required this.charWidth,
    this.exitDuration = 0.52,
  });
}
