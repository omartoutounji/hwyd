import 'package:flutter/material.dart';
import 'journal_page.dart';

class Hwyd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black
      ),
      home: JournalPage(),
    );
  }
}