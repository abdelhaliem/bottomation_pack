import 'package:flutter/material.dart';

/// Styling configuration for [AnimatedLogoutButton].
class LogoutButtonStyle {
  /// Background color or gradient start.
  final Color backgroundColor;

  /// Optional gradient for the button background.
  final Gradient? backgroundGradient;

  /// Color of the door and door frame.
  final Color doorColor;

  /// Optional interior glow color when the door opens.
  final Color? doorGlowColor;

  /// Text style for the label (e.g., "Logout").
  final TextStyle textStyle;

  /// Color of the circular progress arc during the loading state.
  final Color progressColor;

  /// Background track color for the progress ring.
  final Color progressTrackColor;

  /// Color of the button in the success state.
  final Color successColor;

  /// Color of the checkmark icon in the success state.
  final Color checkmarkColor;

  /// Shadow color beneath the button.
  final Color shadowColor;

  /// Blur radius of the elevation shadow.
  final double elevation;

  /// Overall height of the button (and diameter when collapsed).
  final double height;

  /// Width of the button in its idle pill shape.
  final double width;

  /// Border radius of the button (defaults to pill shape: height / 2).
  final double? borderRadius;

  const LogoutButtonStyle({
    required this.backgroundColor,
    this.backgroundGradient,
    this.doorColor = Colors.white,
    this.doorGlowColor,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    this.progressColor = Colors.white,
    this.progressTrackColor = const Color(0x33FFFFFF),
    this.successColor = const Color(0xFF10B981),
    this.checkmarkColor = Colors.white,
    this.shadowColor = const Color(0x40000000),
    this.elevation = 8.0,
    this.height = 56.0,
    this.width = 180.0,
    this.borderRadius,
  });

  /// Deep crimson/rose preset — ideal for logout and exit actions.
  factory LogoutButtonStyle.crimson({
    double width = 180.0,
    double height = 56.0,
  }) {
    return LogoutButtonStyle(
      backgroundColor: const Color(0xFFE11D48),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFFF43F5E), Color(0xFFBE123C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      doorColor: Colors.white,
      doorGlowColor: const Color(0x66FFE4E6),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      progressColor: Colors.white,
      progressTrackColor: const Color(0x33FFFFFF),
      successColor: const Color(0xFF10B981),
      checkmarkColor: Colors.white,
      shadowColor: const Color(0x55E11D48),
      elevation: 10.0,
      width: width,
      height: height,
    );
  }

  /// Dark charcoal preset for sleek, modern interfaces.
  factory LogoutButtonStyle.dark({
    double width = 180.0,
    double height = 56.0,
  }) {
    return LogoutButtonStyle(
      backgroundColor: const Color(0xFF1E2128),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF2D323E), Color(0xFF14171E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      doorColor: Colors.white,
      doorGlowColor: const Color(0x55FFFFFF),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      progressColor: Colors.white,
      progressTrackColor: const Color(0x2AFFFFFF),
      successColor: const Color(0xFF10B981),
      checkmarkColor: Colors.white,
      shadowColor: const Color(0x66000000),
      elevation: 10.0,
      width: width,
      height: height,
    );
  }

  /// Vibrant Indigo/Blue preset.
  factory LogoutButtonStyle.indigo({
    double width = 180.0,
    double height = 56.0,
  }) {
    return LogoutButtonStyle(
      backgroundColor: const Color(0xFF4338CA),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFF3730A3)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      doorColor: Colors.white,
      doorGlowColor: const Color(0x66C7D2FE),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      progressColor: Colors.white,
      progressTrackColor: const Color(0x33FFFFFF),
      successColor: const Color(0xFF10B981),
      checkmarkColor: Colors.white,
      shadowColor: const Color(0x554338CA),
      elevation: 10.0,
      width: width,
      height: height,
    );
  }

  /// Creates a copy of this style with the given fields replaced.
  ///
  /// If [backgroundColor] is specified without a [backgroundGradient], any
  /// existing [backgroundGradient] will be cleared by default so the solid
  /// [backgroundColor] takes full effect. You can also pass [clearGradient]
  /// explicitly.
  LogoutButtonStyle copyWith({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    bool? clearGradient,
    Color? doorColor,
    Color? doorGlowColor,
    TextStyle? textStyle,
    Color? progressColor,
    Color? progressTrackColor,
    Color? successColor,
    Color? checkmarkColor,
    Color? shadowColor,
    double? elevation,
    double? height,
    double? width,
    double? borderRadius,
  }) {
    final bool shouldClearGradient = clearGradient ??
        (backgroundColor != null && backgroundGradient == null);

    return LogoutButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: shouldClearGradient
          ? null
          : (backgroundGradient ?? this.backgroundGradient),
      doorColor: doorColor ?? this.doorColor,
      doorGlowColor: doorGlowColor ?? this.doorGlowColor,
      textStyle: textStyle ?? this.textStyle,
      progressColor: progressColor ?? this.progressColor,
      progressTrackColor: progressTrackColor ?? this.progressTrackColor,
      successColor: successColor ?? this.successColor,
      checkmarkColor: checkmarkColor ?? this.checkmarkColor,
      shadowColor: shadowColor ?? this.shadowColor,
      elevation: elevation ?? this.elevation,
      height: height ?? this.height,
      width: width ?? this.width,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
