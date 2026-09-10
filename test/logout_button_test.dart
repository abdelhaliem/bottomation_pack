import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bottomation/bottomation.dart';

void main() {
  group('LogoutButtonStyle Tests', () {
    test('Presets instantiate with correct colors and defaults', () {
      final crimson = LogoutButtonStyle.crimson();
      expect(crimson.backgroundColor, const Color(0xFFE11D48));
      expect(crimson.width, 180.0);
      expect(crimson.height, 56.0);

      final dark = LogoutButtonStyle.dark();
      expect(dark.backgroundColor, const Color(0xFF1E2128));

      final indigo = LogoutButtonStyle.indigo();
      expect(indigo.backgroundColor, const Color(0xFF4338CA));
    });
  });

  group('AnimatedLogoutButton Widget Tests', () {
    testWidgets('Renders idle state correctly with unified API', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.logout(
                text: 'Logout',
                style: LogoutButtonStyle.crimson(),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedLogoutButton), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('Tap triggers sequence through door opening and reaches success', (tester) async {
      bool successCalled = false;
      final controller = AnimatedLogoutButtonController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.logout(
                text: 'Logout',
                controller: controller,
                doorOpenDuration: const Duration(milliseconds: 50),
                letterExitDuration: const Duration(milliseconds: 80),
                doorShutDuration: const Duration(milliseconds: 50),
                collapseDuration: const Duration(milliseconds: 50),
                progressDuration: const Duration(milliseconds: 80),
                successDuration: const Duration(milliseconds: 80),
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

      // Tap logout button
      await tester.tap(find.byType(AnimatedLogoutButton));
      await tester.pump();

      expect(controller.state, BottomationState.animating);

      // Advance through door open and letters exiting
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 80));
      await tester.pump(const Duration(milliseconds: 50));

      // Advance through collapse and progress
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 80));

      // Advance through success
      await tester.pump(const Duration(milliseconds: 80));
      await tester.pumpAndSettle();

      expect(successCalled, isTrue);
      expect(controller.state, BottomationState.success);

      // Test reset
      controller.reset();
      await tester.pumpAndSettle();
      expect(controller.state, BottomationState.idle);
    });

    testWidgets('Custom backgroundColor overrides preset gradient and clears it in decoration',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.logout(
                style: LogoutButtonStyle.crimson(),
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(AnimatedLogoutButton),
        matching: find.byType(Container),
      ).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, Colors.blue);
      expect(decoration.gradient, isNull);
    });

    testWidgets('Custom backgroundGradient applies gradient and leaves color null in decoration',
        (tester) async {
      const gradient = LinearGradient(colors: [Colors.purple, Colors.pink]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.logout(
                backgroundGradient: gradient,
              ),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.descendant(
        of: find.byType(AnimatedLogoutButton),
        matching: find.byType(Container),
      ).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, isNull);
      expect(decoration.gradient, gradient);
    });

    testWidgets('Renders Arabic RTL "تسجيل الخروج" cleanly and triggers animation', (tester) async {
      bool arabicSuccessCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Bottomation.logout(
                text: 'تسجيل الخروج',
                backgroundColor: const Color(0xFFBE123C),
                doorOpenDuration: const Duration(milliseconds: 50),
                letterExitDuration: const Duration(milliseconds: 80),
                doorShutDuration: const Duration(milliseconds: 50),
                collapseDuration: const Duration(milliseconds: 50),
                progressDuration: const Duration(milliseconds: 80),
                successDuration: const Duration(milliseconds: 80),
                autoResetDuration: null,
                onSuccess: () {
                  arabicSuccessCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('تسجيل الخروج'), findsOneWidget);

      await tester.tap(find.byType(AnimatedLogoutButton));
      await tester.pump();

      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 80));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(milliseconds: 80));
      await tester.pump(const Duration(milliseconds: 80));
      await tester.pumpAndSettle();

      expect(arabicSuccessCalled, isTrue);
    });
  });
}
