import 'package:flutter/material.dart';
import '../animations/delete/animated_delete_button.dart';
import '../animations/delete/delete_button_controller.dart';
import '../animations/delete/delete_button_style.dart';
import '../animations/logout/animated_logout_button.dart';
import '../animations/logout/logout_button_controller.dart';
import '../animations/logout/logout_button_style.dart';

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
}
