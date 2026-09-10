import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/bottomation_state.dart';
import '../delete/painters/circular_progress_painter.dart';
import '../delete/painters/success_checkmark_painter.dart';
import 'logout_button_controller.dart';
import 'logout_button_style.dart';
import 'models/logout_letter_exit_data.dart';
import 'painters/door_exit_painter.dart';
import 'painters/exiting_letters_painter.dart';

/// An animated logout button where an architectural door swings open in 3D perspective,
/// the text letters step through the doorway into the other room, the door latches shut,
/// and the button morphs into a circular success checkmark.
///
/// Supports bilingual LTR/RTL layouts (e.g. English "Logout", Arabic "تسجيل الخروج"),
/// dynamic auto-fitting, and full color customization.
class AnimatedLogoutButton extends StatefulWidget {
  /// The label displayed on the button (defaults to "Logout").
  final String text;

  /// Styling configuration for colors, dimensions, and shadows.
  final LogoutButtonStyle? style;

  /// Optional background color shortcut.
  final Color? backgroundColor;

  /// Optional background gradient shortcut.
  final Gradient? backgroundGradient;

  /// Optional door icon color shortcut.
  final Color? doorColor;

  /// Optional interior doorway glow color.
  final Color? doorGlowColor;

  /// Optional text color shortcut.
  final Color? textColor;

  /// Optional progress arc color shortcut.
  final Color? progressColor;

  /// Optional progress track color shortcut.
  final Color? progressTrackColor;

  /// Optional success state color shortcut.
  final Color? successColor;

  /// Optional success checkmark color shortcut.
  final Color? checkmarkColor;

  /// Explicit text direction (LTR or RTL).
  /// If null, it is automatically detected from the text script (e.g., Arabic).
  final TextDirection? textDirection;

  /// Width of the button in its idle state.
  final double? width;

  /// Height of the button (and diameter when collapsed).
  final double? height;

  /// Border radius of the button (defaults to pill shape: height / 2).
  final double? borderRadius;

  /// Elevation shadow blur.
  final double? elevation;

  /// Optional controller to programmatically trigger or reset the button.
  final AnimatedLogoutButtonController? controller;

  /// Invoked immediately when the button is tapped or triggered.
  final Future<void> Function()? onTap;

  /// Invoked when the logout sequence reaches the success state.
  final VoidCallback? onSuccess;

  /// Duration to wait in the success state before auto-resetting.
  /// If null, remains in success until manually reset.
  final Duration? autoResetDuration;

  /// Duration for the door opening swing.
  final Duration doorOpenDuration;

  /// Duration for the letters to march into the doorway.
  final Duration letterExitDuration;

  /// Duration for the door latching shut.
  final Duration doorShutDuration;

  /// Duration for morphing from a pill shape to a circle.
  final Duration collapseDuration;

  /// Duration for the circular progress loading ring.
  final Duration progressDuration;

  /// Duration for the success checkmark animation.
  final Duration successDuration;

  const AnimatedLogoutButton({
    super.key,
    this.text = 'Logout',
    this.style,
    this.backgroundColor,
    this.backgroundGradient,
    this.doorColor,
    this.doorGlowColor,
    this.textColor,
    this.progressColor,
    this.progressTrackColor,
    this.successColor,
    this.checkmarkColor,
    this.textDirection,
    this.width,
    this.height,
    this.borderRadius,
    this.elevation,
    this.controller,
    this.onTap,
    this.onSuccess,
    this.autoResetDuration = const Duration(seconds: 3),
    this.doorOpenDuration = const Duration(milliseconds: 320),
    this.letterExitDuration = const Duration(milliseconds: 950),
    this.doorShutDuration = const Duration(milliseconds: 280),
    this.collapseDuration = const Duration(milliseconds: 380),
    this.progressDuration = const Duration(milliseconds: 1000),
    this.successDuration = const Duration(milliseconds: 700),
  });

  @override
  State<AnimatedLogoutButton> createState() => _AnimatedLogoutButtonState();
}

class _AnimatedLogoutButtonState extends State<AnimatedLogoutButton>
    with TickerProviderStateMixin {
  late BottomationState _state;
  late LogoutButtonStyle _style;

  late AnimationController _doorOpenController;
  late AnimationController _letterExitController;
  late AnimationController _collapseController;
  late AnimationController _progressController;
  late AnimationController _successController;

  late Animation<double> _doorOpenAnimation;
  late Animation<double> _collapseAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _successAnimation;

  List<LogoutLetterExitData> _letterExitData = [];
  double _effectiveWidth = 180.0;
  double _doorWidth = 17.0;
  double _doorHeight = 33.0;
  double _initialDoorLeft = 0.0;
  double _textStartLeft = 0.0;
  double _textWidth = 0.0;
  double _textHeight = 0.0;
  bool _isRtl = false;
  TextDirection _effectiveDirection = TextDirection.ltr;

  @override
  void initState() {
    super.initState();
    _state = BottomationState.idle;
    _style = _resolveEffectiveStyle();

    widget.controller?.attach(
      onTrigger: _startAnimationSequence,
      onReset: _resetToIdle,
    );

    // 1. Door Open / Shut Controller
    _doorOpenController = AnimationController(
      vsync: this,
      duration: widget.doorOpenDuration,
    );
    _doorOpenAnimation = CurvedAnimation(
      parent: _doorOpenController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInQuad,
    );

    // 2. Letters Exit Controller
    _letterExitController = AnimationController(
      vsync: this,
      duration: widget.letterExitDuration,
    );

    // 3. Collapse Controller
    _collapseController = AnimationController(
      vsync: this,
      duration: widget.collapseDuration,
    );
    _collapseAnimation = CurvedAnimation(
      parent: _collapseController,
      curve: Curves.easeInOutCubic,
    );

    // 4. Progress Controller
    _progressController = AnimationController(
      vsync: this,
      duration: widget.progressDuration,
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    // 5. Success Controller
    _successController = AnimationController(
      vsync: this,
      duration: widget.successDuration,
    );
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.easeOutBack,
    );

    _calculateLetterLayout();
  }

  LogoutButtonStyle _resolveEffectiveStyle() {
    final base = widget.style ?? LogoutButtonStyle.crimson();
    return base.copyWith(
      backgroundColor: widget.backgroundColor,
      backgroundGradient: widget.backgroundGradient,
      doorColor: widget.doorColor,
      doorGlowColor: widget.doorGlowColor,
      textStyle: widget.textColor != null
          ? base.textStyle.copyWith(color: widget.textColor)
          : null,
      progressColor: widget.progressColor,
      progressTrackColor: widget.progressTrackColor,
      successColor: widget.successColor,
      checkmarkColor: widget.checkmarkColor,
      elevation: widget.elevation,
      borderRadius: widget.borderRadius,
      width: widget.width,
      height: widget.height,
    );
  }

  bool _detectRtl(String text) {
    if (widget.textDirection != null) {
      return widget.textDirection == TextDirection.rtl;
    }
    final rtlRegex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\u0590-\u05FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    );
    return rtlRegex.hasMatch(text);
  }

  @override
  void didUpdateWidget(covariant AnimatedLogoutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _style = _resolveEffectiveStyle();

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(
        onTrigger: _startAnimationSequence,
        onReset: _resetToIdle,
      );
    }
    if (widget.text != oldWidget.text ||
        widget.textDirection != oldWidget.textDirection ||
        widget.width != oldWidget.width ||
        widget.height != oldWidget.height) {
      _calculateLetterLayout();
    }
  }

  @override
  void dispose() {
    widget.controller?.detach();
    _doorOpenController.dispose();
    _letterExitController.dispose();
    _collapseController.dispose();
    _progressController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _updateState(BottomationState newState) {
    if (mounted) {
      setState(() {
        _state = newState;
      });
      widget.controller?.updateState(newState);
    }
  }

  void _calculateLetterLayout() {
    _isRtl = _detectRtl(widget.text);
    _effectiveDirection = _isRtl ? TextDirection.rtl : TextDirection.ltr;

    final double buttonHeight = _style.height;
    final String text = widget.text;
    final TextStyle textStyle = _style.textStyle;

    final TextPainter fullTextPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: _effectiveDirection,
    )..layout();

    _textWidth = fullTextPainter.width;
    _textHeight = fullTextPainter.height;

    const double iconTextGap = 12.0;
    _doorWidth = buttonHeight * 0.30;
    _doorHeight = buttonHeight * 0.58;

    final double totalContentWidth = _doorWidth + iconTextGap + _textWidth;

    double buttonWidth = _style.width;
    final double minComfortableWidth = totalContentWidth + (buttonHeight * 0.65);
    if (widget.width == null && buttonWidth < minComfortableWidth) {
      buttonWidth = minComfortableWidth;
    } else if (buttonWidth < totalContentWidth + 24.0) {
      buttonWidth = totalContentWidth + 28.0;
    }
    _effectiveWidth = buttonWidth;

    final double initialContentLeft = (buttonWidth - totalContentWidth) / 2;

    double doorLeft;
    double textStartLeft;
    double doorwayThresholdX;
    Offset exitDestination;

    if (_isRtl) {
      // In RTL, door is on the right, text is on the left
      doorLeft = buttonWidth - initialContentLeft - _doorWidth;
      textStartLeft = initialContentLeft;
      doorwayThresholdX = doorLeft + (_doorWidth * 0.25);
      exitDestination = Offset(doorLeft + (_doorWidth * 0.65), buttonHeight / 2);
    } else {
      // In LTR, door is on the left, text is on the right
      doorLeft = initialContentLeft;
      textStartLeft = doorLeft + _doorWidth + iconTextGap;
      doorwayThresholdX = doorLeft + (_doorWidth * 0.75);
      exitDestination = Offset(doorLeft + (_doorWidth * 0.35), buttonHeight / 2);
    }

    _initialDoorLeft = doorLeft;
    _textStartLeft = textStartLeft;

    final List<LogoutLetterExitData> letters = [];
    final int letterCount = text.length;

    for (int i = 0; i < letterCount; i++) {
      final String char = text[i];
      final boxes = fullTextPainter.getBoxesForSelection(
        TextSelection(baseOffset: i, extentOffset: i + 1),
      );

      double charCenterX;
      double charWidth = 14.0;
      if (boxes.isNotEmpty) {
        final box = boxes.first.toRect();
        charCenterX = textStartLeft + box.center.dx;
        charWidth = box.width;
      } else {
        charCenterX = textStartLeft + (i * (_textWidth / math.max(1, letterCount)));
      }

      final Offset charPosition = Offset(charCenterX, buttonHeight / 2);

      // Stagger delay based on distance to door (closest letter exits first)
      final int stepIndex = _isRtl ? (letterCount - 1 - i) : i;
      final double delayFraction = 0.10 + (stepIndex * (0.40 / math.max(1, letterCount - 1)));

      letters.add(LogoutLetterExitData(
        char: char,
        startPosition: charPosition,
        doorwayThresholdX: doorwayThresholdX,
        exitDestination: exitDestination,
        startDelay: delayFraction,
        charWidth: charWidth,
        exitDuration: 0.50,
      ));
    }

    if (mounted) {
      setState(() {
        _letterExitData = letters;
      });
    }
  }

  Future<void> _startAnimationSequence() async {
    if (_state != BottomationState.idle) return;

    _updateState(BottomationState.animating);

    Future<void>? tapOperation;
    if (widget.onTap != null) {
      tapOperation = widget.onTap!();
    }

    // Step 1: Open the door
    await _doorOpenController.forward(from: 0.0);

    // Step 2: Letters walk through the open doorway
    await _letterExitController.forward(from: 0.0);

    // Step 3: Door latches shut
    await _doorOpenController.reverse();

    // Step 4: Collapse button into a circle
    _updateState(BottomationState.loading);
    await _collapseController.forward(from: 0.0);

    // Step 5: Circular progress loading ring
    _progressController.forward(from: 0.0);
    if (tapOperation != null) {
      await Future.wait([tapOperation, _progressController.forward()]);
    } else {
      await _progressController.forward();
    }

    // Step 6: Success state with checkmark
    _updateState(BottomationState.success);
    await _successController.forward(from: 0.0);
    widget.onSuccess?.call();

    // Step 7: Auto reset if configured
    if (widget.autoResetDuration != null) {
      await Future.delayed(widget.autoResetDuration!);
      if (mounted && _state == BottomationState.success) {
        _resetToIdle();
      }
    }
  }

  void _resetToIdle() {
    _doorOpenController.reset();
    _letterExitController.reset();
    _collapseController.reverse();
    _progressController.reset();
    _successController.reset();
    _updateState(BottomationState.idle);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _doorOpenController,
        _letterExitController,
        _collapseController,
        _progressController,
        _successController,
      ]),
      builder: (context, child) {
        final double buttonHeight = _style.height;
        final double circleDiameter = buttonHeight;
        final double pillWidth = _effectiveWidth;

        final double currentWidth = pillWidth -
            ((pillWidth - circleDiameter) * _collapseAnimation.value);

        final bool isSuccess = _state == BottomationState.success;
        final double successValue = _successAnimation.value;

        Color currentColor = _style.backgroundColor;
        if (isSuccess) {
          currentColor = Color.lerp(
            _style.backgroundColor,
            _style.successColor,
            successValue,
          )!;
        }

        final double idleDoorLeft = _initialDoorLeft;
        final double centerDoorLeft = (currentWidth - _doorWidth) / 2;
        final double currentDoorLeft = idleDoorLeft +
            ((centerDoorLeft - idleDoorLeft) * _collapseAnimation.value);
        final double doorTop = (buttonHeight - _doorHeight) / 2;

        return Center(
          child: GestureDetector(
            onTap: _state == BottomationState.idle ? _startAnimationSequence : null,
            child: Container(
              width: currentWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  _style.borderRadius ?? (buttonHeight / 2),
                ),
                color: currentColor,
                gradient: isSuccess ? null : _style.backgroundGradient,
                boxShadow: [
                  BoxShadow(
                    color: isSuccess
                        ? _style.successColor.withValues(alpha: 0.45)
                        : _style.shadowColor,
                    blurRadius: _style.elevation + (isSuccess ? 6.0 : 0.0),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // 1. 3D Architectural Door (opens in perspective & latches shut)
                  if (_state != BottomationState.success || successValue < 0.95)
                    Positioned(
                      left: currentDoorLeft,
                      top: doorTop,
                      child: Transform.scale(
                        scale: (1.0 - successValue).clamp(0.0, 1.0),
                        child: CustomPaint(
                          size: Size(_doorWidth, _doorHeight),
                          painter: DoorExitPainter(
                            color: _style.doorColor,
                            glowColor: _style.doorGlowColor,
                            doorOpenProgress: _doorOpenAnimation.value,
                            isRtl: _isRtl,
                            strokeWidth: 2.2,
                          ),
                        ),
                      ),
                    ),

                  // 2A. Idle Text
                  if (_state == BottomationState.idle)
                    Positioned(
                      left: _textStartLeft,
                      top: (buttonHeight - _textHeight) / 2,
                      child: SizedBox(
                        width: _textWidth,
                        height: _textHeight,
                        child: Text(
                          widget.text,
                          textDirection: _effectiveDirection,
                          style: _style.textStyle,
                        ),
                      ),
                    ),

                  // 2B. Exiting Letters Walking through Doorway
                  if (_state == BottomationState.animating)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ExitingLettersPainter(
                          letters: _letterExitData,
                          animationProgress: _letterExitController.value,
                          textStyle: _style.textStyle,
                          textDirection: _effectiveDirection,
                          isRtl: _isRtl,
                        ),
                      ),
                    ),

                  // 3. Circular Progress Ring (Loading state)
                  if (_state == BottomationState.loading &&
                      _collapseAnimation.value > 0.9)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CircularProgressPainter(
                          progress: _progressAnimation.value,
                          progressColor: _style.progressColor,
                          trackColor: _style.progressTrackColor,
                          strokeWidth: 3.2,
                        ),
                      ),
                    ),

                  // 4. Success Checkmark
                  if (_state == BottomationState.success && successValue > 0.01)
                    Transform.scale(
                      scale: 0.8 + (0.25 * _successAnimation.value),
                      child: SizedBox(
                        width: circleDiameter,
                        height: circleDiameter,
                        child: CustomPaint(
                          painter: SuccessCheckmarkPainter(
                            progress: _successAnimation.value,
                            color: _style.checkmarkColor,
                            strokeWidth: 3.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
