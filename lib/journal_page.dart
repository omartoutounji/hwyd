import 'package:flutter/material.dart';

class JournalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/hwyd_logo.png", width: 50)
                  ],
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLines: null,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'how was your day?',
                        hintStyle: TextStyle(fontSize: 40)
                    ),
                    showCursor: true,
                    cursorColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                    style: TextStyle(fontSize: 90),
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