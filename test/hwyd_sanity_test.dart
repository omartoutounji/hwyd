import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hwyd/screens/journal_page.dart';

void main() {
  testWidgets('Hwyd sanity test', (WidgetTester tester) async {
    // Isolate the JournalPage widget out of our app safely so we can test
    // it as testWidget and set things up
    Widget testWidget = const MediaQuery(
        data: MediaQueryData(), child: MaterialApp(home: JournalPage()));
    await tester.pumpWidget(testWidget);
    await tester.ensureVisible(find.byWidget(testWidget));

    // Ensure user can see the menu, share and add icons
    await tester.ensureVisible(find.byIcon(Icons.menu));
    await tester.ensureVisible(find.byIcon(Icons.ios_share));
    await tester.ensureVisible(find.byIcon(Icons.add));

    // Enter journal: "my day was great!"
    expect(find.byType(TextField), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'my day was great!');
    await tester.pumpAndSettle();

    // Ensure text is actually there
    expect(find.text('my day was great!'), findsOneWidget);

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
    await tester.ensureVisible(find.byType(Drawer));

    // Ensure there is one journal in the drawer only
    expect(find.byType(ListTile), findsOneWidget);

    // Rename journal to "journal1"
    await tester.tap(find.byIcon(Icons.drive_file_rename_outline));
    await tester.enterText(find.byType(TextField).first, 'journal1');
    expect(find.text('journal1'), findsOneWidget);

    // Close drawer
    await tester.tap(find.byIcon(Icons.ios_share), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);

    // Create new journal
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Open drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
    await tester.ensureVisible(find.byType(Drawer));

    // Ensure there are now 2 journals journal in the drawer only
    expect(find.byType(ListTile), findsNWidgets(2));
    await tester.pumpAndSettle();

    // Ensure snackbar is not visible
    expect(find.byType(SnackBarAction), findsNothing);

    // Delete first journal
    await tester.drag(find.byType(Dismissible).first, const Offset(500, 0));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsOneWidget);

    // Make sure snackbar now appears
    expect(find.byType(SnackBarAction), findsOneWidget);
    await tester.ensureVisible(find.byType(SnackBarAction));

    // Close drawer
    await tester.tap(find.byIcon(Icons.ios_share), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsNothing);

    // Undo delete journal
    await tester.tap(find.widgetWithText(SnackBarAction, "Undo"),
        warnIfMissed: false);
    await tester.pumpAndSettle();

    // Open Drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
    await tester.ensureVisible(find.byType(Drawer));

    // Check deleted journal is now restored
    expect(find.byType(ListTile), findsNWidgets(2));
  });
}
