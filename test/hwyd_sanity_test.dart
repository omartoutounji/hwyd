import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hwyd/screens/journal_page.dart';

void main() {
  testWidgets('Hwyd sanity test', (WidgetTester tester) async {
    // Isolate the JournalPage widget out of our app safely so we can test it as testWidget
    Widget testWidget = const MediaQuery(
        data: MediaQueryData(), child: MaterialApp(home: JournalPage()));

    // Rebuild the widget tree for our test widget
    await tester.pumpWidget(testWidget);

    // Ensure testWidget is visible
    await tester.ensureVisible(find.byWidget(testWidget));

    // Ensure user can see the menu, share and add icons
    await tester.ensureVisible(find.byIcon(Icons.menu));
    await tester.ensureVisible(find.byIcon(Icons.ios_share));
    await tester.ensureVisible(find.byIcon(Icons.add));

    // Search for our hint text and verify there is one widget
    expect(find.byType(TextField), findsOneWidget);

    // Enter a mock journal
    await tester.enterText(find.byType(TextField), 'my day was great!');

    // Expect to find the new mock journal on screen
    expect(find.text('my day was great!'), findsOneWidget);

    // Press on menu icon to open drawer
    await tester.tap(find.byIcon(Icons.menu));

    // Rebuild widget tree or wait for animation to complete
    await tester.pumpAndSettle();

    // Expect the Drawer to be there in widget tree
    expect(find.byType(Drawer), findsOneWidget);

    // Ensure the Drawer is visible
    await tester.ensureVisible(find.byType(Drawer));

    // Ensure there is one journal in the drawer only
    expect(find.byType(ListTile), findsOneWidget);

    // Tap on rename name button to rename journal
    await tester.tap(find.byIcon(Icons.drive_file_rename_outline));

    // Rename journal to 'journal1'. We're using the first text field we find.
    await tester.enterText(find.byType(TextField).first, 'journal1');

    // Expect to find renamed journal in Drawer
    expect(find.text('journal1'), findsOneWidget);

    // Press on menu icon to close drawer. Disable warning since we intend to tap off-screen share button
    await tester.tap(find.byIcon(Icons.ios_share), warnIfMissed: false);

    // Rebuild widget tree or wait for animation to complete
    await tester.pumpAndSettle();

    // Expect the Drawer to be gone in widget tree
    expect(find.byType(Drawer), findsNothing);

    // Press on add button to create new jounrnal
    await tester.tap(find.byIcon(Icons.add));

    // Rebuild widget tree or wait for animation to complete
    await tester.pumpAndSettle();

    // Press on menu icon to open drawer
    await tester.tap(find.byIcon(Icons.menu));

    // Rebuild widget tree or wait for animation to complete
    await tester.pumpAndSettle();

    // Expect the Drawer to be there in widget tree
    expect(find.byType(Drawer), findsOneWidget);

    // Ensure the Drawer is visible
    await tester.ensureVisible(find.byType(Drawer));

    // Ensure there are 2 journals journal in the drawer only
    expect(find.byType(ListTile), findsNWidgets(2));

    // Rebuild widget tree or wait for animation to complete
    await tester.pumpAndSettle();

    // Dismiss 1 journal
    await tester.drag(find.byType(Dismissible).first, const Offset(500, 0));

    // Build the widget until the dismiss animation ends.
    await tester.pumpAndSettle();

    // Ensure that one journal is now deleted and there is only 1 left
    expect(find.byType(ListTile), findsOneWidget);
  });
}
