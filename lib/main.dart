import 'package:flutter/material.dart';
import 'hwyd.dart';
import 'package:flutter/services.dart';

import 'journal_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: <String, WidgetBuilder> {
      '/j': (BuildContext context) => JournalPage(),
    },
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
    ),
    home: Hwyd(),
  ));
}
