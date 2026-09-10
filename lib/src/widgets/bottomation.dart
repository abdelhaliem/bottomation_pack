import 'package:flutter/material.dart';
import '../animations/add_to_cart/animated_add_to_cart_button.dart';
import '../animations/add_to_cart/add_to_cart_button_controller.dart';
import '../animations/add_to_cart/add_to_cart_button_style.dart';
import '../animations/delete/animated_delete_button.dart';
import '../animations/delete/delete_button_controller.dart';
import '../animations/delete/delete_button_style.dart';
import '../animations/logout/animated_logout_button.dart';
import '../animations/logout/logout_button_controller.dart';
import '../animations/logout/logout_button_style.dart';
import '../animations/place_order/animated_place_order_button.dart';
import '../animations/place_order/place_order_button_controller.dart';
import '../animations/place_order/place_order_button_style.dart';

/// The primary unified API for [bottomation].
/// Provides convenient factory methods for every available button animation.
class Bottomation {
  const Bottomation._();

  /// Creates a delightful animated delete button with letter suction,
  /// morphing circle progress, and success checkmark feedback.
  ///
  /// Supports bilingual LTR/RTL layouts (including Arabic "حذف") and full
  /// color customization.
  static Widget delete({
    Key? key,
    String text = 'Delete',
    DeleteButtonStyle? style,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? iconColor,
    Color? textColor,
    Color? progressColor,
    Color? progressTrackColor,
    Color? successColor,
    Color? checkmarkColor,
    TextDirection? textDirection,
    double? width,
    double? height,
    double? borderRadius,
    double? elevation,
    AnimatedDeleteButtonController? controller,
    Future<void> Function()? onTap,
    VoidCallback? onSuccess,
    Duration? autoResetDuration = const Duration(seconds: 3),
    Duration suctionDuration = const Duration(milliseconds: 1200),
    Duration collapseDuration = const Duration(milliseconds: 380),
    Duration progressDuration = const Duration(milliseconds: 1100),
    Duration successDuration = const Duration(milliseconds: 700),
  }) {
    return AnimatedDeleteButton(
      key: key,
      text: text,
      style: style,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      iconColor: iconColor,
      textColor: textColor,
      progressColor: progressColor,
      progressTrackColor: progressTrackColor,
      successColor: successColor,
      checkmarkColor: checkmarkColor,
      textDirection: textDirection,
      width: width,
      height: height,
      borderRadius: borderRadius,
      elevation: elevation,
      controller: controller,
      onTap: onTap,
      onSuccess: onSuccess,
      autoResetDuration: autoResetDuration,
      suctionDuration: suctionDuration,
      collapseDuration: collapseDuration,
      progressDuration: progressDuration,
      successDuration: successDuration,
    );
  }

  /// Creates an animated logout button featuring an architectural 3D swinging door,
  /// letters exiting through the doorway threshold, door latching shut, circle morphing,
  /// and animated success checkmark feedback.
  ///
  /// Supports bilingual LTR/RTL layouts (including Arabic "تسجيل الخروج") and full
  /// color customization.
  static Widget logout({
    Key? key,
    String text = 'Logout',
    LogoutButtonStyle? style,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? doorColor,
    Color? doorGlowColor,
    Color? textColor,
    Color? progressColor,
    Color? progressTrackColor,
    Color? successColor,
    Color? checkmarkColor,
    TextDirection? textDirection,
    double? width,
    double? height,
    double? borderRadius,
    double? elevation,
    AnimatedLogoutButtonController? controller,
    Future<void> Function()? onTap,
    VoidCallback? onSuccess,
    Duration? autoResetDuration = const Duration(seconds: 3),
    Duration doorOpenDuration = const Duration(milliseconds: 320),
    Duration letterExitDuration = const Duration(milliseconds: 950),
    Duration doorShutDuration = const Duration(milliseconds: 280),
    Duration collapseDuration = const Duration(milliseconds: 380),
    Duration progressDuration = const Duration(milliseconds: 1000),
    Duration successDuration = const Duration(milliseconds: 700),
  }) {
    return AnimatedLogoutButton(
      key: key,
      text: text,
      style: style,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      doorColor: doorColor,
      doorGlowColor: doorGlowColor,
      textColor: textColor,
      progressColor: progressColor,
      progressTrackColor: progressTrackColor,
      successColor: successColor,
      checkmarkColor: checkmarkColor,
      textDirection: textDirection,
      width: width,
      height: height,
      borderRadius: borderRadius,
      elevation: elevation,
      controller: controller,
      onTap: onTap,
      onSuccess: onSuccess,
      autoResetDuration: autoResetDuration,
      doorOpenDuration: doorOpenDuration,
      letterExitDuration: letterExitDuration,
      doorShutDuration: doorShutDuration,
      collapseDuration: collapseDuration,
      progressDuration: progressDuration,
      successDuration: successDuration,
    );
  }

  /// Creates a delightful animated add-to-cart button featuring a factory conveyor belt,
  /// overhead laser scanning, cardboard box flap sealing, shipping label stamping,
  /// realistic shopping cart drop physics, and a popping "+1" badge.
  ///
  /// Supports bilingual LTR/RTL layouts (including Arabic "أضف إلى السلة") and full
  /// color customization.
  static Widget addToCart({
    Key? key,
    String text = 'Add to cart',
    String successText = 'Added',
    AddToCartButtonStyle? style,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? boxColor,
    Color? boxTapeColor,
    Color? cartColor,
    Color? badgeColor,
    Color? badgeTextColor,
    Color? conveyorColor,
    Color? scannerLaserColor,
    Color? textColor,
    Color? successColor,
    Color? checkmarkColor,
    TextDirection? textDirection,
    double? width,
    double? height,
    double? borderRadius,
    double? elevation,
    AnimatedAddToCartButtonController? controller,
    Future<void> Function()? onTap,
    VoidCallback? onSuccess,
    Duration? autoResetDuration = const Duration(seconds: 3),
    Duration deploymentDuration = const Duration(milliseconds: 300),
    Duration boxEntranceDuration = const Duration(milliseconds: 650),
    Duration scanAndSealDuration = const Duration(milliseconds: 650),
    Duration transportAndDropDuration = const Duration(milliseconds: 700),
    Duration bounceAndBadgeDuration = const Duration(milliseconds: 450),
    Duration successDuration = const Duration(milliseconds: 500),
  }) {
    return AnimatedAddToCartButton(
      key: key,
      text: text,
      successText: successText,
      style: style,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      boxColor: boxColor,
      boxTapeColor: boxTapeColor,
      cartColor: cartColor,
      badgeColor: badgeColor,
      badgeTextColor: badgeTextColor,
      conveyorColor: conveyorColor,
      scannerLaserColor: scannerLaserColor,
      textColor: textColor,
      successColor: successColor,
      checkmarkColor: checkmarkColor,
      textDirection: textDirection,
      width: width,
      height: height,
      borderRadius: borderRadius,
      elevation: elevation,
      controller: controller,
      onTap: onTap,
      onSuccess: onSuccess,
      autoResetDuration: autoResetDuration,
      deploymentDuration: deploymentDuration,
      boxEntranceDuration: boxEntranceDuration,
      scanAndSealDuration: scanAndSealDuration,
      transportAndDropDuration: transportAndDropDuration,
      bounceAndBadgeDuration: bounceAndBadgeDuration,
      successDuration: successDuration,
    );
  }

  /// Creates an interactive animated place-order button with top-down delivery
  /// truck, articulating rear cargo doors, automated package loading, illuminated headlights,
  /// dashed road lane markings, and an acceleration drive-off sequence.
  ///
  /// Supports bilingual LTR/RTL layouts (e.g. Arabic "إتمام الطلب" -> "تم تأكيد الطلب")
  /// and direct customization for every vehicle, package, road, and button property.
  static Widget placeOrder({
    Key? key,
    String text = 'Complete Order',
    String successText = 'Order Placed',
    PlaceOrderButtonStyle? style,
    Color? backgroundColor,
    Gradient? backgroundGradient,
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
    TextDirection? textDirection,
    double? width,
    double? height,
    double? borderRadius,
    double? elevation,
    AnimatedPlaceOrderButtonController? controller,
    Future<void> Function()? onTap,
    VoidCallback? onSuccess,
    Duration? autoResetDuration = const Duration(seconds: 3),
    Duration entryDuration = const Duration(milliseconds: 550),
    Duration doorsOpenDuration = const Duration(milliseconds: 320),
    Duration packageLoadDuration = const Duration(milliseconds: 500),
    Duration doorsCloseDuration = const Duration(milliseconds: 300),
    Duration headlightsAndRoadDuration = const Duration(milliseconds: 450),
    Duration driveOffDuration = const Duration(milliseconds: 650),
    Duration successDuration = const Duration(milliseconds: 450),
  }) {
    return AnimatedPlaceOrderButton(
      key: key,
      text: text,
      successText: successText,
      style: style,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      truckColor: truckColor,
      cargoColor: cargoColor,
      windshieldColor: windshieldColor,
      headlightColor: headlightColor,
      headlightBeamColor: headlightBeamColor,
      packageColor: packageColor,
      packageTapeColor: packageTapeColor,
      roadLineColor: roadLineColor,
      textColor: textColor,
      successColor: successColor,
      successTextColor: successTextColor,
      checkmarkColor: checkmarkColor,
      textDirection: textDirection,
      width: width,
      height: height,
      borderRadius: borderRadius,
      elevation: elevation,
      controller: controller,
      onTap: onTap,
      onSuccess: onSuccess,
      autoResetDuration: autoResetDuration,
      entryDuration: entryDuration,
      doorsOpenDuration: doorsOpenDuration,
      packageLoadDuration: packageLoadDuration,
      doorsCloseDuration: doorsCloseDuration,
      headlightsAndRoadDuration: headlightsAndRoadDuration,
      driveOffDuration: driveOffDuration,
      successDuration: successDuration,
    );
  }
}
