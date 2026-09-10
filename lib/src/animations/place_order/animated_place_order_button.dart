import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/bottomation_state.dart';
import 'painters/order_package_painter.dart';
import 'painters/place_order_idle_icon_painter.dart';
import 'painters/road_line_painter.dart';
import 'painters/top_down_truck_painter.dart';
import 'place_order_button_controller.dart';
import 'place_order_button_style.dart';

/// An interactive animated button featuring a top-down delivery truck,
/// articulating rear cargo doors, automated package loading, illuminated headlights,
/// highway road dashed lane markings, and an acceleration drive-off sequence.
///
/// Built with 100% pure Flutter for 60/120 FPS performance with zero external assets.
class AnimatedPlaceOrderButton extends StatefulWidget {
  /// The idle label displayed on the button (e.g., "Complete Order" or "إتمام الطلب").
  final String text;

  /// The label displayed on the button in the success state (e.g., "Order Placed" or "تم تأكيد الطلب").
  final String successText;

  /// Comprehensive styling configuration. Defaults to [PlaceOrderButtonStyle.dark()].
  final PlaceOrderButtonStyle? style;

  /// Optional background solid color shortcut (clears preset gradient if provided).
  final Color? backgroundColor;

  /// Optional background gradient shortcut.
  final Gradient? backgroundGradient;

  /// Optional delivery truck cab color shortcut.
  final Color? truckColor;

  /// Optional truck cargo box container color shortcut.
  final Color? cargoColor;

  /// Optional windshield color shortcut.
  final Color? windshieldColor;

  /// Optional headlight bulb color shortcut.
  final Color? headlightColor;

  /// Optional headlight illuminated beam cones color shortcut.
  final Color? headlightBeamColor;

  /// Optional package cardboard color shortcut.
  final Color? packageColor;

  /// Optional package tape color shortcut.
  final Color? packageTapeColor;

  /// Optional dashed road lane divider line color shortcut.
  final Color? roadLineColor;

  /// Optional idle label text color shortcut.
  final Color? textColor;

  /// Optional success state color shortcut.
  final Color? successColor;

  /// Optional success text color shortcut.
  final Color? successTextColor;

  /// Optional checkmark icon color shortcut.
  final Color? checkmarkColor;

  /// Explicit text direction override. If null, auto-detects RTL (Arabic/Hebrew).
  final TextDirection? textDirection;

  /// Width of the button.
  final double? width;

  /// Height of the button.
  final double? height;

  /// Border radius of the button (defaults to pill shape: height / 2).
  final double? borderRadius;

  /// Shadow elevation depth.
  final double? elevation;

  /// Optional programmatic controller.
  final AnimatedPlaceOrderButtonController? controller;

  /// Callback when button is tapped in idle state.
  final Future<void> Function()? onTap;

  /// Callback when the animation reaches the final success state.
  final VoidCallback? onSuccess;

  /// Duration to wait in success state before resetting back to idle.
  /// Set to null to disable automatic reset.
  final Duration? autoResetDuration;

  /// Duration for vehicle and package entry.
  final Duration entryDuration;

  /// Duration for rear doors opening.
  final Duration doorsOpenDuration;

  /// Duration for package sliding into cargo hold.
  final Duration packageLoadDuration;

  /// Duration for rear doors closing.
  final Duration doorsCloseDuration;

  /// Duration for headlights illumination and road lane drawing.
  final Duration headlightsAndRoadDuration;

  /// Duration for truck recoil and high-speed drive-off.
  final Duration driveOffDuration;

  /// Duration for the final success reveal.
  final Duration successDuration;

  const AnimatedPlaceOrderButton({
    super.key,
    this.text = 'Complete Order',
    this.successText = 'Order Placed',
    this.style,
    this.backgroundColor,
    this.backgroundGradient,
    this.truckColor,
    this.cargoColor,
    this.windshieldColor,
    this.headlightColor,
    this.headlightBeamColor,
    this.packageColor,
    this.packageTapeColor,
    this.roadLineColor,
    this.textColor,
    this.successColor,
    this.successTextColor,
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
    this.entryDuration = const Duration(milliseconds: 550),
    this.doorsOpenDuration = const Duration(milliseconds: 320),
    this.packageLoadDuration = const Duration(milliseconds: 500),
    this.doorsCloseDuration = const Duration(milliseconds: 300),
    this.headlightsAndRoadDuration = const Duration(milliseconds: 450),
    this.driveOffDuration = const Duration(milliseconds: 650),
    this.successDuration = const Duration(milliseconds: 450),
  });

  @override
  State<AnimatedPlaceOrderButton> createState() =>
      _AnimatedPlaceOrderButtonState();
}

class _AnimatedPlaceOrderButtonState extends State<AnimatedPlaceOrderButton>
    with TickerProviderStateMixin {
  late BottomationState _state;
  late PlaceOrderButtonStyle _style;

  // Controllers for sequential phases
  late AnimationController _entryController;
  late AnimationController _doorsOpenController;
  late AnimationController _packageLoadController;
  late AnimationController _doorsCloseController;
  late AnimationController _headlightsAndRoadController;
  late AnimationController _driveOffController;
  late AnimationController _successController;

  late Animation<double> _entryAnimation;
  late Animation<double> _doorsOpenAnimation;
  late Animation<double> _packageLoadAnimation;
  late Animation<double> _doorsCloseAnimation;
  late Animation<double> _headlightsAndRoadAnimation;
  late Animation<double> _driveOffAnimation;
  late Animation<double> _successAnimation;

  Timer? _autoResetTimer;
  double _effectiveWidth = 220.0;
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

    // Phase 1: Entry
    _entryController = AnimationController(
      vsync: this,
      duration: widget.entryDuration,
    );
    _entryAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    );

    // Phase 2: Doors Open
    _doorsOpenController = AnimationController(
      vsync: this,
      duration: widget.doorsOpenDuration,
    );
    _doorsOpenAnimation = CurvedAnimation(
      parent: _doorsOpenController,
      curve: Curves.easeOutBack,
    );

    // Phase 3: Package Load
    _packageLoadController = AnimationController(
      vsync: this,
      duration: widget.packageLoadDuration,
    );
    _packageLoadAnimation = CurvedAnimation(
      parent: _packageLoadController,
      curve: Curves.easeInOutCubic,
    );

    // Phase 4: Doors Close
    _doorsCloseController = AnimationController(
      vsync: this,
      duration: widget.doorsCloseDuration,
    );
    _doorsCloseAnimation = CurvedAnimation(
      parent: _doorsCloseController,
      curve: Curves.easeInOut,
    );

    // Phase 5: Headlights & Road
    _headlightsAndRoadController = AnimationController(
      vsync: this,
      duration: widget.headlightsAndRoadDuration,
    );
    _headlightsAndRoadAnimation = CurvedAnimation(
      parent: _headlightsAndRoadController,
      curve: Curves.easeOut,
    );

    // Phase 6: Drive Off
    _driveOffController = AnimationController(
      vsync: this,
      duration: widget.driveOffDuration,
    );
    _driveOffAnimation = CurvedAnimation(
      parent: _driveOffController,
      curve: Curves.easeInOut,
    );

    // Phase 7: Success Reveal
    _successController = AnimationController(
      vsync: this,
      duration: widget.successDuration,
    );
    _successAnimation = CurvedAnimation(
      parent: _successController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedPlaceOrderButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _style = _resolveEffectiveStyle();
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.detach();
      widget.controller?.attach(
        onTrigger: _startAnimationSequence,
        onReset: _resetToIdle,
      );
    }
  }

  @override
  void dispose() {
    _autoResetTimer?.cancel();
    widget.controller?.detach();
    _entryController.dispose();
    _doorsOpenController.dispose();
    _packageLoadController.dispose();
    _doorsCloseController.dispose();
    _headlightsAndRoadController.dispose();
    _driveOffController.dispose();
    _successController.dispose();
    super.dispose();
  }

  PlaceOrderButtonStyle _resolveEffectiveStyle() {
    final base = widget.style ?? PlaceOrderButtonStyle.dark();
    final bool hasExplicitSolidBg =
        widget.backgroundColor != null && widget.backgroundGradient == null;

    return base.copyWith(
      backgroundColor: widget.backgroundColor,
      backgroundGradient: widget.backgroundGradient,
      clearGradient: hasExplicitSolidBg,
      truckColor: widget.truckColor,
      cargoColor: widget.cargoColor,
      windshieldColor: widget.windshieldColor,
      headlightColor: widget.headlightColor,
      headlightBeamColor: widget.headlightBeamColor,
      packageColor: widget.packageColor,
      packageTapeColor: widget.packageTapeColor,
      roadLineColor: widget.roadLineColor,
      textColor: widget.textColor,
      successColor: widget.successColor,
      successTextColor: widget.successTextColor,
      checkmarkColor: widget.checkmarkColor,
      width: widget.width,
      height: widget.height,
      borderRadius: widget.borderRadius != null
          ? BorderRadius.circular(widget.borderRadius!)
          : null,
      elevation: widget.elevation,
    );
  }

  void _detectTextDirection(BuildContext context) {
    if (widget.textDirection != null) {
      _effectiveDirection = widget.textDirection!;
      _isRtl = _effectiveDirection == TextDirection.rtl;
      return;
    }

    final hasArabic = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
    ).hasMatch(widget.text);

    if (hasArabic) {
      _effectiveDirection = TextDirection.rtl;
      _isRtl = true;
    } else {
      final ambientDirection = Directionality.maybeOf(context);
      _effectiveDirection = ambientDirection ?? TextDirection.ltr;
      _isRtl = _effectiveDirection == TextDirection.rtl;
    }
  }

  Future<void> _handleTap() async {
    if (_state != BottomationState.idle) return;
    _startAnimationSequence();
    if (widget.onTap != null) {
      await widget.onTap!();
    }
  }

  void _startAnimationSequence() {
    if (_state != BottomationState.idle) return;

    _autoResetTimer?.cancel();
    setState(() {
      _state = BottomationState.animating;
    });
    widget.controller?.updateState(BottomationState.animating);

    // Chain animations sequentially
    _entryController.forward(from: 0.0).then((_) {
      if (!mounted || _state != BottomationState.animating) return;
      _doorsOpenController.forward(from: 0.0).then((_) {
        if (!mounted || _state != BottomationState.animating) return;
        _packageLoadController.forward(from: 0.0).then((_) {
          if (!mounted || _state != BottomationState.animating) return;
          _doorsCloseController.forward(from: 0.0).then((_) {
            if (!mounted || _state != BottomationState.animating) return;
            _headlightsAndRoadController.forward(from: 0.0).then((_) {
              if (!mounted || _state != BottomationState.animating) return;
              _driveOffController.forward(from: 0.0).then((_) {
                if (!mounted || _state != BottomationState.animating) return;
                setState(() {
                  _state = BottomationState.success;
                });
                widget.controller?.updateState(BottomationState.success);
                widget.onSuccess?.call();

                _successController.forward(from: 0.0).then((_) {
                  if (!mounted) return;
                  if (widget.autoResetDuration != null) {
                    _autoResetTimer = Timer(widget.autoResetDuration!, () {
                      if (mounted && _state == BottomationState.success) {
                        _resetToIdle();
                      }
                    });
                  }
                });
              });
            });
          });
        });
      });
    });
  }

  void _resetToIdle() {
    _autoResetTimer?.cancel();
    _entryController.reset();
    _doorsOpenController.reset();
    _packageLoadController.reset();
    _doorsCloseController.reset();
    _headlightsAndRoadController.reset();
    _driveOffController.reset();
    _successController.reset();

    if (mounted) {
      setState(() {
        _state = BottomationState.idle;
      });
      widget.controller?.updateState(BottomationState.idle);
    }
  }

  @override
  Widget build(BuildContext context) {
    _detectTextDirection(context);
    _effectiveWidth = math.max(_style.width, 180.0);
    final effectiveHeight = _style.height;
    final effectiveRadius = _style.borderRadius;

    // Background color determination
    Color effectiveBgColor;
    if (_state == BottomationState.success) {
      effectiveBgColor = Color.lerp(
        _style.backgroundColor,
        _style.successColor,
        _successAnimation.value,
      )!;
    } else {
      effectiveBgColor = _style.backgroundColor;
    }

    return Directionality(
      textDirection: _effectiveDirection,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _entryAnimation,
          _doorsOpenAnimation,
          _packageLoadAnimation,
          _doorsCloseAnimation,
          _headlightsAndRoadAnimation,
          _driveOffAnimation,
          _successAnimation,
        ]),
        builder: (context, child) {
          return Center(
            child: GestureDetector(
              onTap: _state == BottomationState.idle ? _handleTap : null,
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: _effectiveWidth,
                height: effectiveHeight,
                decoration: BoxDecoration(
                  color: _style.backgroundGradient == null
                      ? (_state == BottomationState.success
                          ? effectiveBgColor
                          : _style.backgroundColor)
                      : (_state == BottomationState.success
                          ? effectiveBgColor
                          : null),
                  gradient: _state == BottomationState.success
                      ? null
                      : _style.backgroundGradient,
                  borderRadius: effectiveRadius,
                  boxShadow: [
                    BoxShadow(
                      color: _style.shadowColor,
                      blurRadius: _style.elevation * 2,
                      offset: Offset(0, _style.elevation),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: effectiveRadius,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 1. Idle Content (Text & Icon)
                      if (_state == BottomationState.idle ||
                          (_state == BottomationState.animating &&
                              _entryAnimation.value < 0.4))
                        _buildIdleContent(),

                      // 2. Active Animation Stage (Road, Package, Truck)
                      if (_state == BottomationState.animating)
                        _buildAnimationStage(
                          _effectiveWidth,
                          effectiveHeight,
                        ),

                      // 3. Success Content ("Order Placed ✔")
                      if (_state == BottomationState.success)
                        _buildSuccessContent(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIdleContent() {
    final double opacity = _state == BottomationState.animating
        ? (1.0 - (_entryAnimation.value / 0.4)).clamp(0.0, 1.0)
        : 1.0;

    return Positioned.fill(
      child: Opacity(
        opacity: opacity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size(24, 14),
                  painter: PlaceOrderIdleIconPainter(
                    truckColor: _style.truckColor,
                    cargoColor: _style.cargoColor,
                    isRtl: _isRtl,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.text,
                  style: _style.textStyle ??
                      TextStyle(
                        color: _style.textColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimationStage(double width, double height) {
    // -------------------------------------------------------------
    // Coordinate Layout Calculations:
    // -------------------------------------------------------------
    // LTR:
    // - Truck rests at restingTruckX = width * 0.60
    // - Package rests at restingPackageX = width * 0.18
    // - Truck enters from (width + 50) -> restingTruckX
    // - Package enters from (-40) -> restingPackageX
    // - Package slides from restingPackageX -> (restingTruckX - 12)
    // - Drive off: recoil (-5px) -> rockets to (width + 120)
    // -------------------------------------------------------------
    // RTL:
    // Mirrored horizontally: x_rtl = width - x_ltr
    // -------------------------------------------------------------

    final double restingTruckX = _isRtl ? width * 0.40 : width * 0.60;
    final double restingPackageX = _isRtl ? width * 0.82 : width * 0.18;
    final double entryTruckStart = _isRtl ? -50.0 : width + 50.0;
    final double entryPackageStart = _isRtl ? width + 40.0 : -40.0;

    // 1. Truck Current X
    double truckX;
    if (_driveOffController.isAnimating || _driveOffController.isCompleted) {
      final t = _driveOffAnimation.value;
      if (t < 0.25) {
        // Recoil backward (anticipation)
        final recoilProgress = t / 0.25;
        final recoilDelta = math.sin(recoilProgress * math.pi) * 6.0;
        truckX = _isRtl
            ? restingTruckX + recoilDelta
            : restingTruckX - recoilDelta;
      } else {
        // High speed acceleration forward
        final launchProgress = (t - 0.25) / 0.75;
        final curveValue = Curves.easeInCubic.transform(launchProgress);
        final targetOffscreenX = _isRtl ? -100.0 : width + 100.0;
        truckX = restingTruckX + (targetOffscreenX - restingTruckX) * curveValue;
      }
    } else {
      // Entry phase
      truckX = entryTruckStart +
          (restingTruckX - entryTruckStart) * _entryAnimation.value;
    }

    // 2. Package Current X & Opacity
    double packageX;
    double packageOpacity = 1.0;
    if (_packageLoadController.isAnimating ||
        _packageLoadController.isCompleted) {
      final t = _packageLoadAnimation.value;
      final targetLoadX = _isRtl ? restingTruckX + 12.0 : restingTruckX - 12.0;
      packageX = restingPackageX + (targetLoadX - restingPackageX) * t;

      // When fully inside truck hold, fade into the truck
      if (t > 0.85) {
        packageOpacity = (1.0 - ((t - 0.85) / 0.15)).clamp(0.0, 1.0);
      }
    } else {
      // Entry phase
      packageX = entryPackageStart +
          (restingPackageX - entryPackageStart) * _entryAnimation.value;
    }

    // Hide package once doors are closing/closed or truck driving off
    if (_doorsCloseController.isCompleted ||
        _driveOffController.isAnimating ||
        _driveOffController.isCompleted) {
      packageOpacity = 0.0;
    }

    // 3. Doors Open Progress
    double doorsOpenProgress = 0.0;
    if (_doorsOpenController.isAnimating) {
      doorsOpenProgress = _doorsOpenAnimation.value;
    } else if (_doorsOpenController.isCompleted &&
        !_doorsCloseController.isAnimating &&
        !_doorsCloseController.isCompleted) {
      doorsOpenProgress = 1.0;
    } else if (_doorsCloseController.isAnimating) {
      doorsOpenProgress = 1.0 - _doorsCloseAnimation.value;
    } else {
      doorsOpenProgress = 0.0;
    }

    // 4. Headlights & Road Progress
    double headlightsProgress = 0.0;
    double roadProgress = 0.0;
    if (_headlightsAndRoadController.isAnimating ||
        _headlightsAndRoadController.isCompleted) {
      headlightsProgress = _headlightsAndRoadAnimation.value;
      roadProgress = _headlightsAndRoadAnimation.value;
    }
    // Fade road as truck drives off
    if (_driveOffController.isAnimating) {
      roadProgress = (1.0 - _driveOffAnimation.value).clamp(0.0, 1.0);
    }

    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // A. Dashed Road Divider Line
          if (roadProgress > 0.0)
            Positioned.fill(
              child: CustomPaint(
                painter: RoadLinePainter(
                  roadLineColor: _style.roadLineColor,
                  progress: roadProgress,
                  isRtl: _isRtl,
                ),
              ),
            ),

          // B. Package
          if (packageOpacity > 0.0)
            Positioned(
              left: packageX - 9.0,
              top: (height / 2) - 9.0,
              child: Opacity(
                opacity: packageOpacity,
                child: CustomPaint(
                  size: const Size(18, 18),
                  painter: OrderPackagePainter(
                    packageColor: _style.packageColor,
                    tapeColor: _style.packageTapeColor,
                    size: 18.0,
                  ),
                ),
              ),
            ),

          // C. Top-Down Delivery Truck
          Positioned(
            left: truckX - 27.0,
            top: (height / 2) - 12.0,
            child: CustomPaint(
              size: const Size(54, 24),
              painter: TopDownTruckPainter(
                truckColor: _style.truckColor,
                cargoColor: _style.cargoColor,
                windshieldColor: _style.windshieldColor,
                headlightColor: _style.headlightColor,
                headlightBeamColor: _style.headlightBeamColor,
                doorsOpenProgress: doorsOpenProgress,
                headlightsProgress: headlightsProgress,
                isRtl: _isRtl,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    final double scale = _successAnimation.value;
    final double opacity = _successAnimation.value.clamp(0.0, 1.0);

    return Positioned.fill(
      child: Opacity(
        opacity: opacity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: _style.checkmarkColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.successText,
                  style: _style.successTextStyle ??
                      TextStyle(
                        color: _style.successTextColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
