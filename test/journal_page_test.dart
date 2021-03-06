import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hwyd/hwyd.dart';

void main() {
  testWidgets('Hwyd smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Hwyd());

    // Search for our hint text and verify there is one widget
    expect(find.text('how was your day?'), findsOneWidget);

    // Enter a mock journal
    await tester.enterText(find.byType(TextField), 'my day was great!');

    // Expect to find the new mock journal on screen
    expect(find.text('my day was great!'), findsOneWidget);
  });
}
