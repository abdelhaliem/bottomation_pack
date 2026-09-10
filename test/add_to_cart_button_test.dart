import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bottomation/bottomation.dart';

void main() {
  group('AddToCartButtonStyle Tests', () {
    test('Presets instantiate with correct colors and defaults', () {
      final teal = AddToCartButtonStyle.teal();
      expect(teal.backgroundColor, const Color(0xFF0F2B28));
      expect(teal.width, 200.0);
      expect(teal.height, 56.0);
      expect(teal.boxColor, const Color(0xFFD99B61));

      final dark = AddToCartButtonStyle.dark();
      expect(dark.backgroundColor, const Color(0xFF181A20));

      final indigo = AddToCartButtonStyle.indigo();
      expect(indigo.backgroundColor, const Color(0xFF1E1B4B));
    });

    test('copyWith clears gradient when backgroundColor is provided without gradient', () {
      final teal = AddToCartButtonStyle.teal();
      expect(teal.backgroundGradient, isNotNull);

      final solidRed = teal.copyWith(backgroundColor: Colors.red);
      expect(solidRed.backgroundColor, Colors.red);
      expect(solidRed.backgroundGradient, isNull);
    });
  });

  group('AnimatedAddToCartButton Widget Tests', () {
    testWidgets('Renders idle state correctly with unified API', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.addToCart(
                text: 'Add to cart',
                style: AddToCartButtonStyle.teal(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedAddToCartButton), findsOneWidget);
      expect(find.text('Add to cart'), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('Tap triggers factory animation sequence and reaches success', (tester) async {
      bool successCalled = false;
      final controller = AnimatedAddToCartButtonController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.addToCart(
                text: 'Add to cart',
                controller: controller,
                deploymentDuration: const Duration(milliseconds: 50),
                boxEntranceDuration: const Duration(milliseconds: 60),
                scanAndSealDuration: const Duration(milliseconds: 60),
                transportAndDropDuration: const Duration(milliseconds: 60),
                bounceAndBadgeDuration: const Duration(milliseconds: 50),
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
      await tester.tap(find.byType(AnimatedAddToCartButton));
      await tester.pump();

      expect(controller.state, BottomationState.animating);

      // Advance through deployment and box entrance
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 60));

      // Advance through scan and transport
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 60));

      // Advance through bounce and pause
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 250));

      // Advance through success
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      expect(successCalled, isTrue);
      expect(controller.state, BottomationState.success);
      expect(find.text('Added'), findsOneWidget);

      // Test reset
      controller.reset();
      await tester.pumpAndSettle();
      expect(controller.state, BottomationState.idle);
      expect(find.text('Add to cart'), findsOneWidget);
    });

    testWidgets('Custom backgroundColor overrides preset gradient and clears it in decoration',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.addToCart(
                style: AddToCartButtonStyle.teal(),
                backgroundColor: Colors.purple,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(AnimatedAddToCartButton),
        matching: find.byType(Container),
      ).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, Colors.purple);
      expect(decoration.gradient, isNull);
    });

    testWidgets('Custom backgroundGradient applies gradient and leaves color null in decoration',
        (tester) async {
      const gradient = LinearGradient(colors: [Colors.orange, Colors.red]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.addToCart(
                backgroundGradient: gradient,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(AnimatedAddToCartButton),
        matching: find.byType(Container),
      ).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, isNull);
      expect(decoration.gradient, gradient);
    });

    testWidgets('Renders Arabic RTL "أضف إلى السلة" cleanly and triggers animation', (tester) async {
      bool arabicSuccessCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.addToCart(
                text: 'أضف إلى السلة',
                successText: 'تمت الإضافة',
                backgroundColor: const Color(0xFF0F2B28),
                deploymentDuration: const Duration(milliseconds: 50),
                boxEntranceDuration: const Duration(milliseconds: 60),
                scanAndSealDuration: const Duration(milliseconds: 60),
                transportAndDropDuration: const Duration(milliseconds: 60),
                bounceAndBadgeDuration: const Duration(milliseconds: 50),
                successDuration: const Duration(milliseconds: 50),
                autoResetDuration: null,
                onSuccess: () {
                  arabicSuccessCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('أضف إلى السلة'), findsOneWidget);

      await tester.tap(find.byType(AnimatedAddToCartButton));
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      expect(arabicSuccessCalled, isTrue);
      expect(find.text('تمت الإضافة'), findsOneWidget);
    });
  });
}
