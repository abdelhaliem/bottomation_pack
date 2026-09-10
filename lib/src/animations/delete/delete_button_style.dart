import 'package:flutter/material.dart';

/// Styling configuration for [AnimatedDeleteButton].
class DeleteButtonStyle {
  /// Background color or gradient start.
  final Color backgroundColor;

  /// Optional gradient for the button background.
  final Gradient? backgroundGradient;

  /// Color of the trash can icon in the idle and active states.
  final Color iconColor;

  /// Text style for the label (e.g., "Delete").
  final TextStyle textStyle;

  /// Color of the circular progress arc during the loading state.
  final Color progressColor;

  /// Background track color for the progress ring.
  final Color progressTrackColor;

  /// Color of the button and checkmark in the success state.
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

  const DeleteButtonStyle({
    required this.backgroundColor,
    this.backgroundGradient,
    this.iconColor = Colors.white,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    this.progressColor = Colors.white,
    this.progressTrackColor = const Color(0x33FFFFFF),
    this.successColor = const Color(0xFF22C55E),
    this.checkmarkColor = Colors.white,
    this.shadowColor = const Color(0x40000000),
    this.elevation = 8.0,
    this.height = 56.0,
    this.width = 175.0,
    this.borderRadius,
  });

  /// Dark charcoal preset as seen in the reference video.
  factory DeleteButtonStyle.dark({
    double width = 175.0,
    double height = 56.0,
  }) {
    return DeleteButtonStyle(
      backgroundColor: const Color(0xFF1E2128),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF2A2E39), Color(0xFF14161B)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      iconColor: Colors.white,
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

  /// Vibrant purple gradient preset as seen in the reference video.
  factory DeleteButtonStyle.purple({
    double width = 175.0,
    double height = 56.0,
  }) {
    return DeleteButtonStyle(
      backgroundColor: const Color(0xFF6B21A8),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF8B2FC9), Color(0xFF4C0E78)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      iconColor: Colors.white,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      progressColor: Colors.white,
      progressTrackColor: const Color(0x33FFFFFF),
      successColor: const Color(0xFF059669),
      checkmarkColor: Colors.white,
      shadowColor: const Color(0x557C3AED),
      elevation: 12.0,
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
  DeleteButtonStyle copyWith({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    bool? clearGradient,
    Color? iconColor,
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

    return DeleteButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: shouldClearGradient
          ? null
          : (backgroundGradient ?? this.backgroundGradient),
      iconColor: iconColor ?? this.iconColor,
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
