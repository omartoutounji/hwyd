import 'package:flutter/material.dart';
import 'journal_page.dart';

class Hwyd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Raleway'
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'Raleway'
      ),
      home: JournalPage(),
    );
  }
}