import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hwyd/screens/journal_page.dart';

void main() {
  testWidgets('Hwyd smoke test', (WidgetTester tester) async {
    // Take the JournalPage widget out of our app safely so we can test it without the onboarding page
    Widget testWidget = new MediaQuery(
        data: new MediaQueryData(),
        child: new MaterialApp(home: JournalPage())
    );

    // Load the JournalPage widget
    await tester.pumpWidget(testWidget);

    // Search for our hint text and verify there is one widget
    expect(find.byType(TextField), findsOneWidget);

    // Enter a mock journal
    await tester.enterText(find.byType(TextField), 'my day was great!');

    // Expect to find the new mock journal on screen
    expect(find.text('my day was great!'), findsOneWidget);
  });
}
