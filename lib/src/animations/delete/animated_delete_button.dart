import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/bottomation_state.dart';
import 'delete_button_controller.dart';
import 'delete_button_style.dart';
import 'models/letter_flight_data.dart';
import 'painters/circular_progress_painter.dart';
import 'painters/flying_letters_painter.dart';
import 'painters/success_checkmark_painter.dart';
import 'painters/trash_bin_painter.dart';

/// A delightfully animated delete button featuring suction particle physics,
/// morphing container geometries, circular progress loading, and a success checkmark.
///
/// Supports bilingual LTR/RTL layouts (including Arabic "حذف") with automatic
/// script detection and comprehensive color customization.
class AnimatedDeleteButton extends StatefulWidget {
  /// The label displayed on the button (defaults to "Delete").
  /// Can be English ("Delete"), Arabic ("حذف"), or any other language.
  final String text;

  /// Styling configuration for colors, sizes, and gradients.
  final DeleteButtonStyle? style;

  /// Optional background color shortcut (overrides [style.backgroundColor]).
  final Color? backgroundColor;

  /// Optional background gradient shortcut (overrides [style.backgroundGradient]).
  final Gradient? backgroundGradient;

  /// Optional icon color shortcut (overrides [style.iconColor]).
  final Color? iconColor;

  /// Optional text color shortcut (overrides [style.textStyle.color]).
  final Color? textColor;

  /// Optional circular progress arc color shortcut.
  final Color? progressColor;

  /// Optional circular progress track color shortcut.
  final Color? progressTrackColor;

  /// Optional success state background/pulse color shortcut.
  final Color? successColor;

  /// Optional success state checkmark icon color shortcut.
  final Color? checkmarkColor;

  /// Explicit text direction (LTR or RTL).
  /// If null, it is automatically detected from the text script (e.g., Arabic).
  final TextDirection? textDirection;

  /// Width of the button in its idle pill state.
  final double? width;

  /// Height of the button (and diameter when collapsed).
  final double? height;

  /// Border radius of the button (defaults to pill shape: height / 2).
  final double? borderRadius;

  /// Elevation shadow blur.
  final double? elevation;

  /// Optional controller to programmatically trigger or reset the button.
  final BottomationController? controller;

  /// Invoked immediately when the button is tapped or triggered.
  /// If this returns a [Future], the loading state will wait until the future completes
  /// before proceeding to the success state.
  final Future<void> Function()? onTap;

  /// Invoked when the deletion and loading sequence finishes and enters the success state.
  final VoidCallback? onSuccess;

  /// Duration to wait in the success state before automatically resetting to idle.
  /// If null, the button will remain in the success state until manually reset.
  final Duration? autoResetDuration;

  /// Duration for the letters suction animation.
  final Duration suctionDuration;

  /// Duration for morphing from a pill shape to a circle.
  final Duration collapseDuration;

  /// Duration for the circular progress loading arc.
  final Duration progressDuration;

  /// Duration for the success checkmark animation.
  final Duration successDuration;

  const AnimatedDeleteButton({
    super.key,
    this.text = 'Delete',
    this.style,
    this.backgroundColor,
    this.backgroundGradient,
    this.iconColor,
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
    this.suctionDuration = const Duration(milliseconds: 1200),
    this.collapseDuration = const Duration(milliseconds: 380),
    this.progressDuration = const Duration(milliseconds: 1100),
    this.successDuration = const Duration(milliseconds: 700),
  });

  @override
  State<AnimatedDeleteButton> createState() => _AnimatedDeleteButtonState();
}

class _AnimatedDeleteButtonState extends State<AnimatedDeleteButton>
    with TickerProviderStateMixin {
  late BottomationState _state;
  late DeleteButtonStyle _style;

  // Controllers for each sequential micro-interaction phase
  late AnimationController _suctionController;
  late AnimationController _collapseController;
  late AnimationController _progressController;
  late AnimationController _successController;

  late Animation<double> _lidAngleAnimation;
  late Animation<double> _collapseAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _successAnimation;

  List<LetterFlightData> _letterFlightData = [];
  double _effectiveWidth = 175.0;
  double _initialBinLeft = 0.0;
  double _textStartLeft = 0.0;
  double _textWidth = 0.0;
  double _textHeight = 0.0;
  double _binWidth = 26.0;
  double _binHeight = 26.0;
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

    // 1. Suction & Lid Controller
    _suctionController = AnimationController(
      vsync: this,
      duration: widget.suctionDuration,
    );

    // Lid opens first, stays open while letters fly, then closes
    _lidAngleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -0.65)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(-0.65),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.65, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 20,
      ),
    ]).animate(_suctionController);

    // 2. Collapse Pill-to-Circle Controller
    _collapseController = AnimationController(
      vsync: this,
      duration: widget.collapseDuration,
    );
    _collapseAnimation = CurvedAnimation(
      parent: _collapseController,
      curve: Curves.easeInOutCubic,
    );

    // 3. Progress Ring Controller
    _progressController = AnimationController(
      vsync: this,
      duration: widget.progressDuration,
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    // 4. Success Checkmark & Pulse Controller
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

  DeleteButtonStyle _resolveEffectiveStyle() {
    final base = widget.style ?? DeleteButtonStyle.dark();
    final bool shouldClearGradient =
        widget.backgroundColor != null && widget.backgroundGradient == null;

    return base.copyWith(
      backgroundColor: widget.backgroundColor,
      backgroundGradient: widget.backgroundGradient,
      clearGradient: shouldClearGradient,
      iconColor: widget.iconColor,
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
    // Check for Arabic, Persian, Hebrew scripts
    final rtlRegex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\u0590-\u05FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    );
    return rtlRegex.hasMatch(text);
  }

  @override
  void didUpdateWidget(covariant AnimatedDeleteButton oldWidget) {
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
    _suctionController.dispose();
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

    // Measure total text width and height
    final TextPainter fullTextPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: _effectiveDirection,
    )..layout();

    _textWidth = fullTextPainter.width;
    _textHeight = fullTextPainter.height;

    const double iconTextGap = 12.0;
    _binWidth = buttonHeight * 0.46;
    _binHeight = buttonHeight * 0.46;

    final double totalContentWidth = _binWidth + iconTextGap + _textWidth;

    // Calculate effective button width:
    // Respects explicit width, while auto-expanding if text exceeds boundaries
    double buttonWidth = _style.width;
    final double minComfortableWidth = totalContentWidth + (buttonHeight * 0.65);
    if (widget.width == null && buttonWidth < minComfortableWidth) {
      buttonWidth = minComfortableWidth;
    } else if (buttonWidth < totalContentWidth + 24.0) {
      buttonWidth = totalContentWidth + 28.0;
    }
    _effectiveWidth = buttonWidth;

    final double initialContentLeft = (buttonWidth - totalContentWidth) / 2;
    final double binTop = (buttonHeight - _binHeight) / 2;

    double binLeft;
    double textStartLeft;
    Offset binMouth;

    if (_isRtl) {
      // In RTL, trash bin is positioned on the right, text on the left
      binLeft = buttonWidth - initialContentLeft - _binWidth;
      textStartLeft = initialContentLeft;
      binMouth =
          Offset(binLeft + (_binWidth * 0.5), binTop + (_binHeight * 0.3));
    } else {
      // In LTR, trash bin is on the left, text on the right
      binLeft = initialContentLeft;
      textStartLeft = binLeft + _binWidth + iconTextGap;
      binMouth =
          Offset(binLeft + (_binWidth * 0.5), binTop + (_binHeight * 0.3));
    }

    _initialBinLeft = binLeft;
    _textStartLeft = textStartLeft;

    final List<LetterFlightData> letters = [];
    final int letterCount = text.length;

    for (int i = 0; i < letterCount; i++) {
      final String char = text[i];

      // Measure character exact bounds using getBoxesForSelection
      // This handles Arabic cursive ligature offsets with 100% precision
      final boxes = fullTextPainter.getBoxesForSelection(
        TextSelection(baseOffset: i, extentOffset: i + 1),
      );

      double charCenterX;
      if (boxes.isNotEmpty) {
        charCenterX = textStartLeft + boxes.first.toRect().center.dx;
      } else {
        // Fallback calculation
        charCenterX =
            textStartLeft + (i * (_textWidth / math.max(1, letterCount)));
      }

      final Offset charCenter = Offset(charCenterX, buttonHeight / 2);

      // Arc peak control point curving high in the air towards the bin
      final double midX = _isRtl
          ? (charCenter.dx + binMouth.dx) * 0.52
          : (charCenter.dx + binMouth.dx) * 0.48;
      final double arcHeight = 30.0 + (i * 3.5);
      final Offset controlPoint = Offset(midX, binMouth.dy - arcHeight);

      // Staggered timing from closest to furthest letter
      final double delayFraction =
          0.15 + (i * (0.35 / math.max(1, letterCount - 1)));

      // In RTL, rotation curves clockwise towards the right; in LTR, counter-clockwise
      final double rotationDirection = _isRtl ? 1.0 : -1.0;

      letters.add(LetterFlightData(
        char: char,
        startPosition: charCenter,
        controlPoint: controlPoint,
        targetPosition: binMouth,
        startDelay: delayFraction,
        flightDuration: 0.48,
        targetRotation: rotationDirection * (1.3 + (i * 0.1)),
      ));
    }

    if (mounted) {
      setState(() {
        _letterFlightData = letters;
      });
    }
  }

  Future<void> _startAnimationSequence() async {
    if (_state != BottomationState.idle) return;

    _updateState(BottomationState.animating);

    // Optional user callback execution in parallel with the flow
    Future<void>? tapOperation;
    if (widget.onTap != null) {
      tapOperation = widget.onTap!();
    }

    // Phase 1: Letter Suction & Lid Animation
    await _suctionController.forward(from: 0.0);

    // Phase 2: Collapse Pill into Circle
    _updateState(BottomationState.loading);
    await _collapseController.forward(from: 0.0);

    // Phase 3: Circular Progress Ring Loading
    _progressController.forward(from: 0.0);
    if (tapOperation != null) {
      await Future.wait([tapOperation, _progressController.forward()]);
    } else {
      await _progressController.forward();
    }

    // Phase 4: Success Checkmark & Pulse State
    _updateState(BottomationState.success);
    await _successController.forward(from: 0.0);
    widget.onSuccess?.call();

    // Phase 5: Optional Auto-Reset
    if (widget.autoResetDuration != null) {
      await Future.delayed(widget.autoResetDuration!);
      if (mounted && _state == BottomationState.success) {
        _resetToIdle();
      }
    }
  }

  void _resetToIdle() {
    _suctionController.reset();
    _collapseController.reverse();
    _progressController.reset();
    _successController.reset();
    _updateState(BottomationState.idle);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _suctionController,
        _collapseController,
        _progressController,
        _successController,
      ]),
      builder: (context, child) {
        final double buttonHeight = _style.height;
        final double circleDiameter = buttonHeight;
        final double pillWidth = _effectiveWidth;

        // Current morphing width
        final double currentWidth = pillWidth -
            ((pillWidth - circleDiameter) * _collapseAnimation.value);

        // Smooth background color interpolation on success
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

        // Icon position: lerps from initial position to exact center of the circle
        final double idleBinLeft = _initialBinLeft;
        final double centerBinLeft = (currentWidth - _binWidth) / 2;
        final double currentBinLeft = idleBinLeft +
            ((centerBinLeft - idleBinLeft) * _collapseAnimation.value);
        final double binTop = (buttonHeight - _binHeight) / 2;

        return Center(
          child: GestureDetector(
            onTap: _state == BottomationState.idle
                ? _startAnimationSequence
                : null,
            child: Container(
              width: currentWidth,
              height: buttonHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  _style.borderRadius ?? (buttonHeight / 2),
                ),
                color: isSuccess
                    ? currentColor
                    : (_style.backgroundGradient == null ? currentColor : null),
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
                  // 1. Animated Trash Bin Icon (supports RTL hinge opening)
                  if (_state != BottomationState.success || successValue < 0.95)
                    Positioned(
                      left: currentBinLeft,
                      top: binTop,
                      child: Transform.scale(
                        scale: (1.0 - successValue).clamp(0.0, 1.0),
                        child: CustomPaint(
                          size: Size(_binWidth, _binHeight),
                          painter: TrashBinPainter(
                            color: _style.iconColor,
                            lidAngle: _lidAngleAnimation.value,
                            isFilled: _collapseAnimation.value > 0.6,
                            strokeWidth: 2.2,
                            isRtl: _isRtl,
                          ),
                        ),
                      ),
                    ),

                  // 2A. Idle Text (renders native, connected cursive Arabic or English)
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

                  // 2B. Flying Letters Suction (breaks into particles and flies into bin)
                  if (_state == BottomationState.animating)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: FlyingLettersPainter(
                          letters: _letterFlightData,
                          animationProgress: _suctionController.value,
                          textStyle: _style.textStyle,
                          textDirection: _effectiveDirection,
                        ),
                      ),
                    ),

                  // 3. Circular Progress Ring (Visible during loading phase)
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

                  // 4. Success State Animated Checkmark (Requested Feature)
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
