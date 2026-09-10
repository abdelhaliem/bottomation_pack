import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/bottomation_state.dart';
import 'add_to_cart_button_controller.dart';
import 'add_to_cart_button_style.dart';
import 'painters/conveyor_belt_painter.dart';
import 'painters/factory_box_painter.dart';
import 'painters/isometric_box_painter.dart';
import 'painters/shopping_cart_painter.dart';

/// An interactive animated button featuring a factory conveyor belt,
/// overhead laser scanning, automatic box flap sealing, shipping label stamping,
/// realistic cart drop physics, and a popping "+1" badge.
///
/// Built with 100% pure Flutter for 60/120 FPS performance with zero external assets.
class AnimatedAddToCartButton extends StatefulWidget {
  /// The idle label displayed on the button (e.g., "Add to cart" or "أضف إلى السلة").
  final String text;

  /// The label displayed on the button in the success state (e.g., "Added" or "تمت الإضافة").
  final String successText;

  /// Comprehensive styling configuration. Defaults to [AddToCartButtonStyle.teal()].
  final AddToCartButtonStyle? style;

  /// Optional background solid color shortcut (clears preset gradient if provided).
  final Color? backgroundColor;

  /// Optional background gradient shortcut.
  final Gradient? backgroundGradient;

  /// Optional cardboard kraft color shortcut.
  final Color? boxColor;

  /// Optional box tape / flap seal color shortcut.
  final Color? boxTapeColor;

  /// Optional shopping cart wireframe color shortcut.
  final Color? cartColor;

  /// Optional "+1" badge color shortcut.
  final Color? badgeColor;

  /// Optional "+1" badge text color shortcut.
  final Color? badgeTextColor;

  /// Optional conveyor belt track color shortcut.
  final Color? conveyorColor;

  /// Optional laser scanner beam color shortcut.
  final Color? scannerLaserColor;

  /// Optional idle label text color shortcut.
  final Color? textColor;

  /// Optional success state color shortcut.
  final Color? successColor;

  /// Optional checkmark icon color shortcut.
  final Color? checkmarkColor;

  /// Explicit text direction override. If null, auto-detects RTL (Arabic/Hebrew).
  final TextDirection? textDirection;

  /// Width of the button. Auto-expands if text exceeds width.
  final double? width;

  /// Height of the button.
  final double? height;

  /// Border radius of the button (defaults to pill shape: height / 2).
  final double? borderRadius;

  /// Shadow elevation depth.
  final double? elevation;

  /// Optional programmatic controller.
  final AnimatedAddToCartButtonController? controller;

  /// Callback when button is tapped in idle state.
  final Future<void> Function()? onTap;

  /// Callback when the animation reaches the final success state.
  final VoidCallback? onSuccess;

  /// Duration to wait in success state before resetting back to idle.
  /// Set to null to disable automatic reset.
  final Duration? autoResetDuration;

  /// Duration for conveyor and scanner deployment.
  final Duration deploymentDuration;

  /// Duration for the box entering and reaching the scanner.
  final Duration boxEntranceDuration;

  /// Duration for laser scan, flap folding, and label stamping.
  final Duration scanAndSealDuration;

  /// Duration for transport and drop into the cart.
  final Duration transportAndDropDuration;

  /// Duration for the cart bounce and "+1" badge pop.
  final Duration bounceAndBadgeDuration;

  /// Duration for the final success reveal.
  final Duration successDuration;

  const AnimatedAddToCartButton({
    super.key,
    this.text = 'Add to cart',
    this.successText = 'Added',
    this.style,
    this.backgroundColor,
    this.backgroundGradient,
    this.boxColor,
    this.boxTapeColor,
    this.cartColor,
    this.badgeColor,
    this.badgeTextColor,
    this.conveyorColor,
    this.scannerLaserColor,
    this.textColor,
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
    this.deploymentDuration = const Duration(milliseconds: 300),
    this.boxEntranceDuration = const Duration(milliseconds: 650),
    this.scanAndSealDuration = const Duration(milliseconds: 650),
    this.transportAndDropDuration = const Duration(milliseconds: 700),
    this.bounceAndBadgeDuration = const Duration(milliseconds: 450),
    this.successDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedAddToCartButton> createState() => _AnimatedAddToCartButtonState();
}

class _AnimatedAddToCartButtonState extends State<AnimatedAddToCartButton>
    with TickerProviderStateMixin {
  late BottomationState _state;
  late AddToCartButtonStyle _style;

  // Controllers for sequential factory animation phases
  late AnimationController _deployController;
  late AnimationController _boxEntranceController;
  late AnimationController _scanAndSealController;
  late AnimationController _transportAndDropController;
  late AnimationController _bounceAndBadgeController;
  late AnimationController _successController;

  late Animation<double> _deployAnimation;
  late Animation<double> _boxEntranceAnimation;
  late Animation<double> _scanAndSealAnimation;
  late Animation<double> _transportAndDropAnimation;
  late Animation<double> _bounceAndBadgeAnimation;
  late Animation<double> _successAnimation;

  Timer? _autoResetTimer;
  double _effectiveWidth = 200.0;
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

    // 1. Deployment Controller
    _deployController = AnimationController(
      vsync: this,
      duration: widget.deploymentDuration,
    );
    _deployAnimation = CurvedAnimation(
      parent: _deployController,
      curve: Curves.easeOutCubic,
    );

    // 2. Box Entrance to Scanner
    _boxEntranceController = AnimationController(
      vsync: this,
      duration: widget.boxEntranceDuration,
    );
    _boxEntranceAnimation = CurvedAnimation(
      parent: _boxEntranceController,
      curve: Curves.easeInOutCubic,
    );

    // 3. Scan & Seal Controller
    _scanAndSealController = AnimationController(
      vsync: this,
      duration: widget.scanAndSealDuration,
    );
    _scanAndSealAnimation = CurvedAnimation(
      parent: _scanAndSealController,
      curve: Curves.linear,
    );

    // 4. Transport & Gravity Drop Controller
    _transportAndDropController = AnimationController(
      vsync: this,
      duration: widget.transportAndDropDuration,
    );
    _transportAndDropAnimation = CurvedAnimation(
      parent: _transportAndDropController,
      curve: Curves.easeInOutQuad,
    );

    // 5. Bounce & Badge Controller
    _bounceAndBadgeController = AnimationController(
      vsync: this,
      duration: widget.bounceAndBadgeDuration,
    );
    _bounceAndBadgeAnimation = CurvedAnimation(
      parent: _bounceAndBadgeController,
      curve: Curves.elasticOut,
    );

    // 6. Success Controller
    _successController = AnimationController(
      vsync: this,
      duration: widget.successDuration,
    );
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.easeOutBack,
    );

    _calculateLayout();
  }

  AddToCartButtonStyle _resolveEffectiveStyle() {
    final base = widget.style ?? AddToCartButtonStyle.teal();
    final bool shouldClearGradient =
        widget.backgroundColor != null && widget.backgroundGradient == null;

    return base.copyWith(
      backgroundColor: widget.backgroundColor,
      backgroundGradient: widget.backgroundGradient,
      clearGradient: shouldClearGradient,
      boxColor: widget.boxColor,
      boxTapeColor: widget.boxTapeColor,
      cartColor: widget.cartColor,
      badgeColor: widget.badgeColor,
      badgeTextColor: widget.badgeTextColor,
      conveyorColor: widget.conveyorColor,
      scannerLaserColor: widget.scannerLaserColor,
      textStyle: widget.textColor != null
          ? base.textStyle.copyWith(color: widget.textColor)
          : null,
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

  void _calculateLayout() {
    _isRtl = _detectRtl(widget.text);
    _effectiveDirection = _isRtl ? TextDirection.rtl : TextDirection.ltr;

    final textSpan = TextSpan(
      text: widget.text,
      style: _style.textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: _effectiveDirection,
    )..layout();

    final double requiredWidth = textPainter.width + 68.0;
    _effectiveWidth = math.max(_style.width, requiredWidth);
  }

  @override
  void didUpdateWidget(covariant AnimatedAddToCartButton oldWidget) {
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
      _calculateLayout();
    }
  }

  @override
  void dispose() {
    _autoResetTimer?.cancel();
    widget.controller?.detach();
    _deployController.dispose();
    _boxEntranceController.dispose();
    _scanAndSealController.dispose();
    _transportAndDropController.dispose();
    _bounceAndBadgeController.dispose();
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

  Future<void> _startAnimationSequence() async {
    if (_state != BottomationState.idle) return;
    _autoResetTimer?.cancel();

    _updateState(BottomationState.animating);

    // Optional user callback execution in parallel
    Future<void>? tapOperation;
    if (widget.onTap != null) {
      tapOperation = widget.onTap!();
    }

    // 1. Deploy conveyor & scanner
    await _deployController.forward(from: 0.0);

    // 2. Box enters along conveyor to center scanner
    await _boxEntranceController.forward(from: 0.0);

    // 3. Scan with laser, seal flaps, and stamp label
    await _scanAndSealController.forward(from: 0.0);

    // 4. Cart arrives, conveyor rolls box and drops it in cart
    await _transportAndDropController.forward(from: 0.0);

    // 5. Cart bounces and +1 badge pops up
    if (tapOperation != null) {
      await Future.wait([tapOperation, _bounceAndBadgeController.forward(from: 0.0)]);
    } else {
      await _bounceAndBadgeController.forward(from: 0.0);
    }

    // 6. Transition to Success state
    _updateState(BottomationState.success);
    await _successController.forward(from: 0.0);
    widget.onSuccess?.call();

    // Optional Auto Reset
    if (widget.autoResetDuration != null) {
      _autoResetTimer = Timer(widget.autoResetDuration!, () {
        if (mounted && _state == BottomationState.success) {
          _resetToIdle();
        }
      });
    }
  }

  void _resetToIdle() {
    _autoResetTimer?.cancel();
    _deployController.reset();
    _boxEntranceController.reset();
    _scanAndSealController.reset();
    _transportAndDropController.reset();
    _bounceAndBadgeController.reset();
    _successController.reset();
    _updateState(BottomationState.idle);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _deployController,
        _boxEntranceController,
        _scanAndSealController,
        _transportAndDropController,
        _bounceAndBadgeController,
        _successController,
      ]),
      builder: (context, child) {
        final double buttonHeight = _style.height;
        final double pillWidth = _effectiveWidth;
        final bool isSuccess = _state == BottomationState.success;
        final double successValue = _successAnimation.value;

        // Color transition to success
        Color currentColor = _style.backgroundColor;
        if (isSuccess) {
          currentColor = Color.lerp(
            _style.backgroundColor,
            _style.successColor,
            successValue,
          )!;
        }

        // Coordinates & Animation Metrics
        final deployValue = _deployAnimation.value;
        final entranceValue = _boxEntranceAnimation.value;
        final scanValue = _scanAndSealAnimation.value;
        final transportValue = _transportAndDropAnimation.value;
        final bounceValue = _bounceAndBadgeAnimation.value;

        // Box dimensions
        const boxWidth = 26.0;
        const boxHeight = 22.0;

        // Scanner position
        final scannerCenterX = pillWidth / 2;
        final boxCenterTargetX = scannerCenterX - (boxWidth / 2);

        // Cart position
        const cartWidth = 32.0;
        const cartHeight = 28.0;
        final cartTargetX = _isRtl ? 16.0 : (pillWidth - cartWidth - 16.0);
        final cartCenterBasketX = _isRtl ? (cartTargetX + 10.0) : (cartTargetX + 16.0);

        // Horizontal conveyor track Y
        final trackY = buttonHeight * 0.72;
        final boxOnTrackY = trackY - boxHeight + 2.0;

        // Box X & Y calculation across phases
        double currentBoxX;
        double currentBoxY = boxOnTrackY;
        double currentBoxScale = 1.0;
        double currentBoxRotate = 0.0;

        final startBoxX = _isRtl ? (pillWidth + 10.0) : (-boxWidth - 10.0);

        if (_boxEntranceController.isAnimating || entranceValue < 1.0) {
          // Phase 2: Rolling from edge to scanner center
          currentBoxX = startBoxX + (boxCenterTargetX - startBoxX) * entranceValue;
        } else if (_transportAndDropController.value <= 0.0) {
          // Phase 3: Resting under scanner
          currentBoxX = boxCenterTargetX;
        } else {
          // Phase 4: Moving towards cart and dropping
          final rollEndThreshold = 0.65;
          if (transportValue <= rollEndThreshold) {
            final rollFraction = (transportValue / rollEndThreshold).clamp(0.0, 1.0);
            final rollDestX = _isRtl ? (cartTargetX + 22.0) : (cartTargetX - 10.0);
            currentBoxX = boxCenterTargetX + (rollDestX - boxCenterTargetX) * rollFraction;
          } else {
            // Parabolic drop into cart basket
            final dropFraction = ((transportValue - rollEndThreshold) / (1.0 - rollEndThreshold)).clamp(0.0, 1.0);
            final dropStartX = _isRtl ? (cartTargetX + 22.0) : (cartTargetX - 10.0);
            final dropTargetX = cartCenterBasketX;

            currentBoxX = dropStartX + (dropTargetX - dropStartX) * dropFraction;
            // Arc trajectory
            final arcPeak = -8.0 * math.sin(dropFraction * math.pi);
            currentBoxY = boxOnTrackY + (dropFraction * 4.0) + arcPeak;
            currentBoxScale = 1.0 - (dropFraction * 0.22);
            currentBoxRotate = (_isRtl ? -1.0 : 1.0) * (dropFraction * 0.25);
          }
        }

        // Box Sealing & Labeling state
        final bool isScanning = scanValue > 0.05 && scanValue < 0.50;
        final double laserProg = (scanValue * 2.0).clamp(0.0, 1.0);
        final double flapProg = ((scanValue - 0.35) / 0.40).clamp(0.0, 1.0);
        final double labelProg = ((scanValue - 0.60) / 0.35).clamp(0.0, 1.0);

        // Cart appearance
        final cartEntrance = (transportValue * 2.5).clamp(0.0, 1.0);

        // Continuous roller progress
        final double rollerProg = entranceValue + (transportValue * 1.5);

        return Center(
          child: GestureDetector(
            onTap: _state == BottomationState.idle ? _startAnimationSequence : null,
            child: Container(
              width: pillWidth,
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
                  // 1. Factory Conveyor Belt Track & Overhead Scanner
                  if (_state == BottomationState.animating && successValue < 0.95)
                    Positioned.fill(
                      child: CustomPaint(
                        painter: ConveyorBeltPainter(
                          trackColor: _style.conveyorColor,
                          rollerColor: _style.conveyorRollerColor,
                          scannerColor: _style.scannerColor,
                          indicatorColor: _style.scannerLaserColor,
                          rollProgress: rollerProg,
                          entranceProgress: deployValue * (1.0 - successValue),
                          isScanning: isScanning,
                          isRtl: _isRtl,
                        ),
                      ),
                    ),

                  // 2. Shopping Cart & +1 Pop Badge
                  if (_state == BottomationState.animating && cartEntrance > 0.01 && successValue < 0.95)
                    Positioned(
                      left: cartTargetX,
                      top: (buttonHeight - cartHeight) / 2 + 3.0,
                      child: Transform.scale(
                        scale: (1.0 - successValue).clamp(0.0, 1.0),
                        child: CustomPaint(
                          size: const Size(cartWidth, cartHeight),
                          painter: ShoppingCartPainter(
                            cartColor: _style.cartColor,
                            badgeColor: _style.badgeColor,
                            badgeTextColor: _style.badgeTextColor,
                            cartEntranceProgress: cartEntrance,
                            bounceProgress: bounceValue,
                            badgeProgress: bounceValue,
                            isRtl: _isRtl,
                          ),
                        ),
                      ),
                    ),

                  // 3. Cardboard Shipping Box
                  if (_state == BottomationState.animating && deployValue > 0.5 && successValue < 0.95)
                    Positioned(
                      left: currentBoxX,
                      top: currentBoxY,
                      child: Transform.translate(
                        offset: Offset.zero,
                        child: Transform.rotate(
                          angle: currentBoxRotate,
                          child: Transform.scale(
                            scale: currentBoxScale * (1.0 - successValue).clamp(0.0, 1.0),
                            child: CustomPaint(
                              size: const Size(boxWidth, boxHeight),
                              painter: FactoryBoxPainter(
                                boxColor: _style.boxColor,
                                flapColor: _style.boxColor,
                                tapeColor: _style.boxTapeColor,
                                laserColor: _style.scannerLaserColor,
                                flapCloseProgress: flapProg,
                                labelProgress: labelProg,
                                laserProgress: laserProg,
                                isScanning: isScanning,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // 4. Idle State: Isometric 3D Box Icon + Label
                  if (_state == BottomationState.idle || (_state == BottomationState.animating && deployValue < 0.95))
                    Positioned.fill(
                      child: Center(
                        child: Opacity(
                          opacity: (1.0 - deployValue).clamp(0.0, 1.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Directionality(
                                textDirection: _effectiveDirection,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomPaint(
                                      size: const Size(20.0, 20.0),
                                      painter: IsometricBoxPainter(
                                        color: _style.textStyle.color ?? Colors.white,
                                        strokeWidth: 1.8,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      widget.text,
                                      style: _style.textStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // 5. Success State: Emerald Checkmark + "Added" Label
                  if (_state == BottomationState.success)
                    Positioned.fill(
                      child: Center(
                        child: Opacity(
                          opacity: successValue.clamp(0.0, 1.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Directionality(
                                textDirection: _effectiveDirection,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _style.checkmarkColor.withValues(alpha: 0.20),
                                      ),
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: _style.checkmarkColor,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.successText,
                                      style: _style.textStyle.copyWith(
                                        color: _style.checkmarkColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
