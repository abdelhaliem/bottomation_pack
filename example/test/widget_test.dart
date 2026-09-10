import 'package:flutter_test/flutter_test.dart';
import 'package:bottomation_example/main.dart';

void main() {
  testWidgets('BottomationExampleApp renders showcase page', (tester) async {
    await tester.pumpWidget(const BottomationExampleApp());
    expect(find.text('Bottomation'), findsOneWidget);
    expect(find.text('Purple Gradient'), findsOneWidget);
    expect(find.text('Dark Charcoal'), findsOneWidget);
    expect(find.text('Arabic RTL (حذف. المنتج)'), findsOneWidget);
    expect(find.text('Crimson Rose'), findsOneWidget);
    expect(find.text('Arabic RTL (تسجيل الخروج)'), findsOneWidget);
  });
}
