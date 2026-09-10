/// The current execution state of an animated button in [bottomation].
enum BottomationState {
  /// The initial idle state waiting for user interaction.
  idle,

  /// Active micro-interaction animation (e.g., suction/throwing elements).
  animating,

  /// Processing / loading state (e.g., circular spinner / progress ring).
  loading,

  /// Action succeeded (e.g., checkmark / success bounce).
  success,
}
