import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bottomation/bottomation.dart';

void main() {
  group('PlaceOrderButtonStyle Tests', () {
    test('Presets instantiate with correct colors and defaults', () {
      final dark = PlaceOrderButtonStyle.dark();
      expect(dark.backgroundColor, const Color(0xFF1E2028));
      expect(dark.truckColor, const Color(0xFF2563EB));
      expect(dark.cargoColor, const Color(0xFFF3F4F6));
      expect(dark.headlightColor, const Color(0xFFFBBF24));
      expect(dark.packageColor, const Color(0xFFD99B61));
      expect(dark.width, 220.0);
      expect(dark.height, 54.0);

      final midnight = PlaceOrderButtonStyle.midnight();
      expect(midnight.backgroundColor, const Color(0xFF0F172A));
      expect(midnight.truckColor, const Color(0xFFF97316));

      final emerald = PlaceOrderButtonStyle.emerald();
      expect(emerald.backgroundColor, const Color(0xFF064E3B));
      expect(emerald.truckColor, const Color(0xFF10B981));
    });

    test('copyWith clearGradient flag clears gradient properly', () {
      const gradient = LinearGradient(colors: [Colors.black, Colors.white]);
      final styleWithGrad = PlaceOrderButtonStyle.dark().copyWith(
        backgroundGradient: gradient,
      );
      expect(styleWithGrad.backgroundGradient, isNotNull);

      final styleSolid = styleWithGrad.copyWith(
        backgroundColor: Colors.red,
        clearGradient: true,
      );
      expect(styleSolid.backgroundColor, Colors.red);
      expect(styleSolid.backgroundGradient, isNull);
    });
  });

  group('AnimatedPlaceOrderButton Widget Tests', () {
    testWidgets('Renders idle state correctly with unified API', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.placeOrder(
                text: 'Complete Order',
                style: PlaceOrderButtonStyle.dark(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedPlaceOrderButton), findsOneWidget);
      expect(find.text('Complete Order'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('Tap triggers sequence through drive-off and reaches success', (tester) async {
      bool successCalled = false;
      final controller = AnimatedPlaceOrderButtonController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.placeOrder(
                text: 'Complete Order',
                successText: 'Order Placed',
                controller: controller,
                entryDuration: const Duration(milliseconds: 50),
                doorsOpenDuration: const Duration(milliseconds: 40),
                packageLoadDuration: const Duration(milliseconds: 50),
                doorsCloseDuration: const Duration(milliseconds: 40),
                headlightsAndRoadDuration: const Duration(milliseconds: 50),
                driveOffDuration: const Duration(milliseconds: 60),
                successDuration: const Duration(milliseconds: 50),
                autoResetDuration: null,
                onSuccess: () {
                  successCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(controller.state, BottomationState.idle);

      // Tap button
      await tester.tap(find.byType(AnimatedPlaceOrderButton));
      await tester.pump();
      expect(controller.state, BottomationState.animating);

      // Advance through entry (50ms)
      await tester.pump(const Duration(milliseconds: 60));
      // Advance through doors open (40ms)
      await tester.pump(const Duration(milliseconds: 50));
      // Advance through package load (50ms)
      await tester.pump(const Duration(milliseconds: 60));
      // Advance through doors close (40ms)
      await tester.pump(const Duration(milliseconds: 50));
      // Advance through headlights & road (50ms)
      await tester.pump(const Duration(milliseconds: 60));
      // Advance through drive-off (60ms)
      await tester.pump(const Duration(milliseconds: 70));

      expect(successCalled, isTrue);
      expect(controller.state, BottomationState.success);

      // Advance through success animation (50ms)
      await tester.pump(const Duration(milliseconds: 60));
      expect(find.text('Order Placed'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('Custom backgroundColor overrides preset and does not crash BoxDecoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.placeOrder(
                text: 'Order Now',
                backgroundColor: const Color(0xFF112233),
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(AnimatedPlaceOrderButton),
          matching: find.byType(AnimatedContainer),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFF112233));
      expect(decoration.gradient, isNull);
    });

    testWidgets('Custom backgroundGradient applies gradient and leaves color null in decoration', (tester) async {
      const customGrad = LinearGradient(colors: [Colors.blue, Colors.purple]);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.placeOrder(
                text: 'Order Now',
                backgroundGradient: customGrad,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(AnimatedPlaceOrderButton),
          matching: find.byType(AnimatedContainer),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, customGrad);
      expect(decoration.color, isNull);
    });

    testWidgets('Programmatic controller trigger and reset work seamlessly', (tester) async {
      final controller = AnimatedPlaceOrderButtonController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.placeOrder(
                text: 'Place Order',
                controller: controller,
                entryDuration: const Duration(milliseconds: 30),
                doorsOpenDuration: const Duration(milliseconds: 30),
                packageLoadDuration: const Duration(milliseconds: 30),
                doorsCloseDuration: const Duration(milliseconds: 30),
                headlightsAndRoadDuration: const Duration(milliseconds: 30),
                driveOffDuration: const Duration(milliseconds: 30),
                successDuration: const Duration(milliseconds: 30),
              ),
            ),
          ),
        ),
      );

      expect(controller.state, BottomationState.idle);

      // Trigger via controller
      controller.trigger();
      await tester.pump();
      expect(controller.state, BottomationState.animating);

      // Reset back to idle
      controller.reset();
      await tester.pump();
      expect(controller.state, BottomationState.idle);
      expect(find.text('Place Order'), findsOneWidget);
    });

    testWidgets('Renders Arabic RTL "إتمام الطلب" cleanly and runs animation', (tester) async {
      bool successFired = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.placeOrder(
                text: 'إتمام الطلب',
                successText: 'تم تأكيد الطلب',
                entryDuration: const Duration(milliseconds: 30),
                doorsOpenDuration: const Duration(milliseconds: 30),
                packageLoadDuration: const Duration(milliseconds: 30),
                doorsCloseDuration: const Duration(milliseconds: 30),
                headlightsAndRoadDuration: const Duration(milliseconds: 30),
                driveOffDuration: const Duration(milliseconds: 30),
                successDuration: const Duration(milliseconds: 30),
                autoResetDuration: null,
                onSuccess: () => successFired = true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('إتمام الطلب'), findsOneWidget);

      await tester.tap(find.byType(AnimatedPlaceOrderButton));
      await tester.pump();

      // Pump through each chained controller
      await tester.pump(const Duration(milliseconds: 35)); // entry
      await tester.pump(const Duration(milliseconds: 35)); // doors open
      await tester.pump(const Duration(milliseconds: 35)); // package load
      await tester.pump(const Duration(milliseconds: 35)); // doors close
      await tester.pump(const Duration(milliseconds: 35)); // headlights & road
      await tester.pump(const Duration(milliseconds: 35)); // drive off
      await tester.pump(const Duration(milliseconds: 35)); // success

      expect(successFired, isTrue);
      expect(find.text('تم تأكيد الطلب'), findsOneWidget);
    });
  });
}
