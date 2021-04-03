import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import "dart:math";

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String greeting;
  final Image logo = Image.asset("assets/hwyd_logo.png", width: 50);

  @override
  void initState() {
    super.initState();
    greeting = getRandomGreeting();
  }

  TextStyle getStyle(double size) {
    return GoogleFonts.raleway(
        textStyle: TextStyle(fontWeight: FontWeight.w200, fontSize: size)
    );
  }

  String getRandomGreeting() {
    var greetings = ['how was your day?','what is going on?','what\'s up?',
      'what\'s sizzling?','sup!','what\'s new?',
      'how are you doing?', 'what\'s cracking?', 'life, huh?'];
    final _random = new Random();
    return greetings[_random.nextInt(greetings.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    logo
                  ],
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: greeting,
                      hintStyle: getStyle(30),
                    ),
                    showCursor: true,
                    cursorColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                    style: getStyle(80),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}