import 'package:flutter/material.dart';

/// Styling configuration for [AnimatedAddToCartButton].
class AddToCartButtonStyle {
  /// Background solid color.
  final Color backgroundColor;

  /// Optional background gradient.
  final Gradient? backgroundGradient;

  /// Color of the factory conveyor belt track.
  final Color conveyorColor;

  /// Color of the conveyor belt rollers/ticks.
  final Color conveyorRollerColor;

  /// Color of the overhead scanner unit.
  final Color scannerColor;

  /// Color of the vertical laser scanning beam.
  final Color scannerLaserColor;

  /// Main cardboard kraft color of the package.
  final Color boxColor;

  /// Color of the box tape / flaps when sealed.
  final Color boxTapeColor;

  /// Color of the wireframe shopping cart.
  final Color cartColor;

  /// Background color of the "+1" popping badge.
  final Color badgeColor;

  /// Text color inside the "+1" popping badge.
  final Color badgeTextColor;

  /// Text style for idle and success states.
  final TextStyle textStyle;

  /// Success state badge / ring background color.
  final Color successColor;

  /// Checkmark icon color in success state.
  final Color checkmarkColor;

  /// Drop shadow color.
  final Color shadowColor;

  /// Elevation shadow blur depth.
  final double elevation;

  /// Button height (and minimum diameter).
  final double height;

  /// Idle pill width.
  final double width;

  /// Border radius (defaults to height / 2 for a smooth pill shape).
  final double? borderRadius;

  const AddToCartButtonStyle({
    required this.backgroundColor,
    this.backgroundGradient,
    this.conveyorColor = const Color(0xFF1E3A34),
    this.conveyorRollerColor = const Color(0xFF2E564E),
    this.scannerColor = const Color(0xFF2A4D45),
    this.scannerLaserColor = const Color(0xFFEF4444),
    this.boxColor = const Color(0xFFD99B61),
    this.boxTapeColor = const Color(0xFFB87843),
    this.cartColor = Colors.white,
    this.badgeColor = const Color(0xFFF59E0B),
    this.badgeTextColor = Colors.white,
    this.textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    this.successColor = const Color(0xFF10B981),
    this.checkmarkColor = Colors.white,
    this.shadowColor = const Color(0x550F2B28),
    this.elevation = 8.0,
    this.height = 56.0,
    this.width = 200.0,
    this.borderRadius,
  });

  /// Deep modern Teal / Emerald preset (default non-black theme).
  factory AddToCartButtonStyle.teal({
    double width = 200.0,
    double height = 56.0,
  }) {
    return AddToCartButtonStyle(
      backgroundColor: const Color(0xFF0F2B28),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF163E3A), Color(0xFF0B201E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      conveyorColor: const Color(0xFF1E3A34),
      conveyorRollerColor: const Color(0xFF2E564E),
      scannerColor: const Color(0xFF2A4D45),
      scannerLaserColor: const Color(0xFFEF4444),
      boxColor: const Color(0xFFD99B61),
      boxTapeColor: const Color(0xFFB87843),
      cartColor: Colors.white,
      badgeColor: const Color(0xFFF59E0B),
      badgeTextColor: Colors.white,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      successColor: const Color(0xFF10B981),
      checkmarkColor: Colors.white,
      shadowColor: const Color(0x550F2B28),
      elevation: 8.0,
      width: width,
      height: height,
    );
  }

  /// Sleek dark charcoal factory preset.
  factory AddToCartButtonStyle.dark({
    double width = 200.0,
    double height = 56.0,
  }) {
    return AddToCartButtonStyle(
      backgroundColor: const Color(0xFF181A20),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF242833), Color(0xFF121418)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      conveyorColor: const Color(0xFF2A2E39),
      conveyorRollerColor: const Color(0xFF3B4150),
      scannerColor: const Color(0xFF333845),
      scannerLaserColor: const Color(0xFFFF3B30),
      boxColor: const Color(0xFFD99B61),
      boxTapeColor: const Color(0xFFB87843),
      cartColor: Colors.white,
      badgeColor: const Color(0xFFF97316),
      badgeTextColor: Colors.white,
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      successColor: const Color(0xFF10B981),
      checkmarkColor: Colors.white,
      shadowColor: const Color(0x66000000),
      elevation: 10.0,
      width: width,
      height: height,
    );
  }

  /// Vibrant midnight indigo / electric preset.
  factory AddToCartButtonStyle.indigo({
    double width = 200.0,
    double height = 56.0,
  }) {
    return AddToCartButtonStyle(
      backgroundColor: const Color(0xFF1E1B4B),
      backgroundGradient: const LinearGradient(
        colors: [Color(0xFF2E2875), Color(0xFF151336)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      conveyorColor: const Color(0xFF312E81),
      conveyorRollerColor: const Color(0xFF4338CA),
      scannerColor: const Color(0xFF3730A3),
      scannerLaserColor: const Color(0xFFF43F5E),
      boxColor: const Color(0xFFE0A36D),
      boxTapeColor: const Color(0xFFC07F47),
      cartColor: Colors.white,
      badgeColor: const Color(0xFFFBBF24),
      badgeTextColor: const Color(0xFF1E1B4B),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
      successColor: const Color(0xFF10B981),
      checkmarkColor: Colors.white,
      shadowColor: const Color(0x551E1B4B),
      elevation: 9.0,
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
  AddToCartButtonStyle copyWith({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    bool? clearGradient,
    Color? conveyorColor,
    Color? conveyorRollerColor,
    Color? scannerColor,
    Color? scannerLaserColor,
    Color? boxColor,
    Color? boxTapeColor,
    Color? cartColor,
    Color? badgeColor,
    Color? badgeTextColor,
    TextStyle? textStyle,
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

    return AddToCartButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: shouldClearGradient
          ? null
          : (backgroundGradient ?? this.backgroundGradient),
      conveyorColor: conveyorColor ?? this.conveyorColor,
      conveyorRollerColor: conveyorRollerColor ?? this.conveyorRollerColor,
      scannerColor: scannerColor ?? this.scannerColor,
      scannerLaserColor: scannerLaserColor ?? this.scannerLaserColor,
      boxColor: boxColor ?? this.boxColor,
      boxTapeColor: boxTapeColor ?? this.boxTapeColor,
      cartColor: cartColor ?? this.cartColor,
      badgeColor: badgeColor ?? this.badgeColor,
      badgeTextColor: badgeTextColor ?? this.badgeTextColor,
      textStyle: textStyle ?? this.textStyle,
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
