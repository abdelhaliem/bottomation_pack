import 'package:flutter/material.dart';

/// Styling options for [AnimatedPlaceOrderButton].
@immutable
class PlaceOrderButtonStyle {
  /// Background color of the button.
  final Color backgroundColor;

  /// Background gradient of the button. If provided, overrides [backgroundColor]
  /// unless [backgroundColor] is explicitly passed without a gradient.
  final Gradient? backgroundGradient;

  /// Color of the delivery truck cab / driver cabin.
  final Color truckColor;

  /// Color of the truck cargo box / container body.
  final Color cargoColor;

  /// Color of the truck windshield.
  final Color windshieldColor;

  /// Color of the headlights bulb fixtures.
  final Color headlightColor;

  /// Color of the headlight illuminated light beam cones.
  final Color headlightBeamColor;

  /// Color of the cardboard shipping package.
  final Color packageColor;

  /// Color of the package center sealing tape.
  final Color packageTapeColor;

  /// Color of the dashed road divider lane line.
  final Color roadLineColor;

  /// Text color for the idle state.
  final Color textColor;

  /// Background or accent color on success state.
  final Color successColor;

  /// Text color for the success state.
  final Color successTextColor;

  /// Color of the success checkmark.
  final Color checkmarkColor;

  /// Optional text style for the idle text.
  final TextStyle? textStyle;

  /// Optional text style for the success text.
  final TextStyle? successTextStyle;

  /// Width of the button in idle state.
  final double width;

  /// Height of the button.
  final double height;

  /// Border radius of the button.
  final BorderRadius borderRadius;

  /// Elevation shadow depth of the button.
  final double elevation;

  /// Shadow color of the button.
  final Color shadowColor;

  const PlaceOrderButtonStyle({
    this.backgroundColor = const Color(0xFF1E2028),
    this.backgroundGradient,
    this.truckColor = const Color(0xFF2563EB),
    this.cargoColor = const Color(0xFFF3F4F6),
    this.windshieldColor = const Color(0xFF1E293B),
    this.headlightColor = const Color(0xFFFBBF24),
    this.headlightBeamColor = const Color(0x33FBBF24),
    this.packageColor = const Color(0xFFD99B61),
    this.packageTapeColor = const Color(0xFFB87843),
    this.roadLineColor = const Color(0xFFE5E7EB),
    this.textColor = Colors.white,
    this.successColor = const Color(0xFF10B981),
    this.successTextColor = Colors.white,
    this.checkmarkColor = const Color(0xFF10B981),
    this.textStyle,
    this.successTextStyle,
    this.width = 220.0,
    this.height = 54.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(27.0)),
    this.elevation = 4.0,
    this.shadowColor = const Color(0x33000000),
  });

  /// Modern Asphalt / Cobalt delivery truck theme (Default).
  factory PlaceOrderButtonStyle.dark() {
    return const PlaceOrderButtonStyle(
      backgroundColor: Color(0xFF1E2028),
      truckColor: Color(0xFF2563EB),
      cargoColor: Color(0xFFF3F4F6),
      windshieldColor: Color(0xFF1E293B),
      headlightColor: Color(0xFFFBBF24),
      headlightBeamColor: Color(0x33FBBF24),
      packageColor: Color(0xFFD99B61),
      packageTapeColor: Color(0xFFB87843),
      roadLineColor: Color(0xFFE5E7EB),
      textColor: Colors.white,
      successColor: Color(0xFF10B981),
      checkmarkColor: Color(0xFF10B981),
    );
  }

  /// Midnight Navy / Electric Orange delivery truck theme.
  factory PlaceOrderButtonStyle.midnight() {
    return const PlaceOrderButtonStyle(
      backgroundColor: Color(0xFF0F172A),
      truckColor: Color(0xFFF97316),
      cargoColor: Color(0xFFE2E8F0),
      windshieldColor: Color(0xFF0F172A),
      headlightColor: Color(0xFFFEF08A),
      headlightBeamColor: Color(0x40FEF08A),
      packageColor: Color(0xFFD99B61),
      packageTapeColor: Color(0xFFB87843),
      roadLineColor: Color(0xFF94A3B8),
      textColor: Colors.white,
      successColor: Color(0xFF059669),
      checkmarkColor: Color(0xFF10B981),
    );
  }

  /// Emerald / Electric Green delivery theme.
  factory PlaceOrderButtonStyle.emerald() {
    return const PlaceOrderButtonStyle(
      backgroundColor: Color(0xFF064E3B),
      truckColor: Color(0xFF10B981),
      cargoColor: Color(0xFFF0FDF4),
      windshieldColor: Color(0xFF064E3B),
      headlightColor: Color(0xFFFDE047),
      headlightBeamColor: Color(0x35FDE047),
      packageColor: Color(0xFFD99B61),
      packageTapeColor: Color(0xFFB87843),
      roadLineColor: Color(0xFFA7F3D0),
      textColor: Colors.white,
      successColor: Color(0xFF047857),
      checkmarkColor: Color(0xFF10B981),
    );
  }

  /// Creates a copy with optionally overridden values.
  /// If [clearGradient] is true, [backgroundGradient] will be set to `null`.
  PlaceOrderButtonStyle copyWith({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    bool clearGradient = false,
    Color? truckColor,
    Color? cargoColor,
    Color? windshieldColor,
    Color? headlightColor,
    Color? headlightBeamColor,
    Color? packageColor,
    Color? packageTapeColor,
    Color? roadLineColor,
    Color? textColor,
    Color? successColor,
    Color? successTextColor,
    Color? checkmarkColor,
    TextStyle? textStyle,
    TextStyle? successTextStyle,
    double? width,
    double? height,
    BorderRadius? borderRadius,
    double? elevation,
    Color? shadowColor,
  }) {
    return PlaceOrderButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: clearGradient
          ? null
          : (backgroundGradient ?? this.backgroundGradient),
      truckColor: truckColor ?? this.truckColor,
      cargoColor: cargoColor ?? this.cargoColor,
      windshieldColor: windshieldColor ?? this.windshieldColor,
      headlightColor: headlightColor ?? this.headlightColor,
      headlightBeamColor: headlightBeamColor ?? this.headlightBeamColor,
      packageColor: packageColor ?? this.packageColor,
      packageTapeColor: packageTapeColor ?? this.packageTapeColor,
      roadLineColor: roadLineColor ?? this.roadLineColor,
      textColor: textColor ?? this.textColor,
      successColor: successColor ?? this.successColor,
      successTextColor: successTextColor ?? this.successTextColor,
      checkmarkColor: checkmarkColor ?? this.checkmarkColor,
      textStyle: textStyle ?? this.textStyle,
      successTextStyle: successTextStyle ?? this.successTextStyle,
      width: width ?? this.width,
      height: height ?? this.height,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
    );
  }
}
