import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bottomation/bottomation.dart';

void main() {
  group('TrajectoryUtils Tests', () {
    test('quadraticBezier calculates endpoints and midpoint correctly', () {
      const p0 = Offset(0, 0);
      const p1 = Offset(50, 100);
      const p2 = Offset(100, 0);

      expect(
          TrajectoryUtils.quadraticBezier(p0, p1, p2, 0.0), const Offset(0, 0));
      expect(TrajectoryUtils.quadraticBezier(p0, p1, p2, 1.0),
          const Offset(100, 0));
      expect(TrajectoryUtils.quadraticBezier(p0, p1, p2, 0.5),
          const Offset(50, 50));
    });
  });

  group('DeleteButtonStyle Tests', () {
    test('Dark and Purple presets instantiate with correct defaults', () {
      final dark = DeleteButtonStyle.dark();
      expect(dark.backgroundColor, const Color(0xFF1E2128));
      expect(dark.width, 175.0);
      expect(dark.height, 56.0);

      final purple = DeleteButtonStyle.purple();
      expect(purple.backgroundColor, const Color(0xFF6B21A8));
      expect(purple.width, 175.0);
      expect(purple.height, 56.0);
    });
  });

  group('AnimatedDeleteButton Widget Tests', () {
    testWidgets('Renders idle state correctly with unified API',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.delete(
                text: 'Delete',
                style: DeleteButtonStyle.dark(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedDeleteButton), findsOneWidget);
    });

    testWidgets('Tap triggers sequence and reaches success callback',
        (tester) async {
      bool successCalled = false;
      final controller = BottomationController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.delete(
                text: 'Delete',
                controller: controller,
                suctionDuration: const Duration(milliseconds: 100),
                collapseDuration: const Duration(milliseconds: 50),
                progressDuration: const Duration(milliseconds: 100),
                successDuration: const Duration(milliseconds: 100),
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

      // Tap the button
      await tester.tap(find.byType(AnimatedDeleteButton));
      await tester.pump();

      expect(controller.state, BottomationState.animating);

      // Advance through suction
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 50));

      // Advance through collapse and progress
      await tester.pump(const Duration(milliseconds: 100));

      // Advance through success
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(successCalled, isTrue);
      expect(controller.state, BottomationState.success);

      // Test reset
      controller.reset();
      await tester.pumpAndSettle();
      expect(controller.state, BottomationState.idle);
    });

    testWidgets('Custom colors shortcut overrides default style',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.delete(
                text: 'Delete',
                backgroundColor: Colors.indigo,
                textColor: Colors.yellow,
                iconColor: Colors.amber,
              ),
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(AnimatedDeleteButton);
      expect(buttonFinder, findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('Renders Arabic text and runs animation sequence cleanly',
        (tester) async {
      bool arabicSuccessCalled = false;
      final controller = BottomationController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.delete(
                text: 'حذف',
                controller: controller,
                suctionDuration: const Duration(milliseconds: 100),
                collapseDuration: const Duration(milliseconds: 50),
                progressDuration: const Duration(milliseconds: 100),
                successDuration: const Duration(milliseconds: 100),
                autoResetDuration: null,
                onSuccess: () {
                  arabicSuccessCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('حذف'), findsOneWidget);
      expect(controller.state, BottomationState.idle);

      // Tap the Arabic button
      await tester.tap(find.byType(AnimatedDeleteButton));
      await tester.pump();

      expect(controller.state, BottomationState.animating);

      // Advance through animation phases
      await tester.pump(const Duration(milliseconds: 100)); // Suction
      await tester.pump(const Duration(milliseconds: 50)); // Collapse
      await tester.pump(const Duration(milliseconds: 100)); // Progress
      await tester.pump(const Duration(milliseconds: 100)); // Success
      await tester.pumpAndSettle();

      expect(arabicSuccessCalled, isTrue);
      expect(controller.state, BottomationState.success);
    });
  });
}
