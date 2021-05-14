import 'package:flutter/material.dart';
import 'journal_page.dart';
import 'dart:convert';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Hwyd extends StatefulWidget {
  const Hwyd({Key key}) : super(key: key);

  @override
  _HwydState createState() => _HwydState();
}

class _HwydState extends State<Hwyd> {
  bool showOnboard;

  @override
  void initState() {
    super.initState();
    _checkOnboardStatus();
  }

  _checkOnboardStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showOnboard = jsonDecode(prefs.getString('onboard') ?? json.encode(true));
    });
  }

  _disableOnboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('onboard', json.encode(false));
  }

  @override
  Widget build(BuildContext context) {
    return showOnboard == true ?
    IntroductionScreen(
          pages: [PageViewModel(
            title: "hwyd",
            body: "Welcome to the world's first nano journal. So simple, all you'll want to do is write your heart out ♥️",
            image: Center(
              child: Image.asset('assets/hwyd_logo.png', width: 250),
            ),
          ), PageViewModel(
            title: "Creating a new note",
            body: "Just tap the hwyd logo to create a new note️",
            image: Center(
              child: Icon(Icons.add, size: 250,),
            ),
          ), PageViewModel(
            title: "Viewing previous notes",
            body: "Swipe from left to right to see other notes. Don't worry about saving, everything auto-saves. Also don't worry about privacy, contents are only saved on your device so no one can access it but you. Not even hwyd.",
            image: Center(
              child: Icon(Icons.swipe, size: 250),
            ),
          )],
          onDone: () {
            _disableOnboard();
            Navigator.pushReplacementNamed(context, '/journal');
          },
          showSkipButton: false,
          next: const Icon(Icons.navigate_next),
          showNextButton: true,
          done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        ) :
    JournalPage();
  }
}