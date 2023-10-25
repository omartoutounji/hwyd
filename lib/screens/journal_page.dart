import 'dart:convert';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/Note.dart';

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String greeting = "";
  List<Note> notes = [];
  int currentNoteIndex = 0;
  final Image logo = Image.asset('assets/hwyd_logo.png', width: 50);
  final textController = TextEditingController();
  double _currentSliderValue = 80;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    greeting = getRandomGreeting();
  }

  Note getNewNote() {
    return Note(getPrettyDate(), "");
  }

  String getPrettyDate() {
    return formatDate(DateTime.now(), [M, ' ', d, ' at ', HH, ':', nn]);
  }

  _loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = List<Note>.from(
          jsonDecode(prefs.getString('notes') ?? json.encode([getNewNote()]))
              .map((i) => Note.fromJson(i)));
      currentNoteIndex = notes.length - 1;
      textController.text = notes[currentNoteIndex].text;
      _currentSliderValue = prefs.getDouble('fontSize') ?? 80;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    _save();
    textController.dispose();
    super.dispose();
  }

  _save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('notes', json.encode(notes));
    prefs.setDouble('fontSize', _currentSliderValue);
  }

  _createNewNote() async {
    setState(() {
      notes.add(getNewNote());
      currentNoteIndex = notes.length - 1;
      textController.text = notes[currentNoteIndex].text;
    });
    _save();
  }

  TextStyle getStyle(double size) {
    return GoogleFonts.raleway(
        textStyle: TextStyle(fontWeight: FontWeight.w200, fontSize: size));
  }

  String getRandomGreeting() {
    var greetings = [
      'how was your day?',
      'what is going on?',
      'what\'s up?',
      'what\'s sizzling?',
      'sup!',
      'what\'s new?',
      'how are you doing?',
      'what\'s cracking?',
      'life, huh?'
    ];
    final _random = new Random();
    return greetings[_random.nextInt(greetings.length)];
  }

  String getSliderLabel() {
    if (_currentSliderValue == 20.0)
      return "S";
    else if (_currentSliderValue == 35.0)
      return "M";
    else if (_currentSliderValue == 50.0)
      return "L";
    else if (_currentSliderValue == 65.0)
      return "XL";
    else
      return "XXL";
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
                    GestureDetector(
                      child: logo,
                      onTap: () {
                        _createNewNote();
                      },
                    )
                  ],
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: textController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: greeting,
                      hintStyle: getStyle(30),
                    ),
                    showCursor: true,
                    cursorColor: MediaQuery.of(context).platformBrightness ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    style: getStyle(_currentSliderValue),
                    textAlign: TextAlign.center,
                    onChanged: notes.length != 0
                        ? (text) {
                            List<String> splittedString = text.split(" ");
                            if (splittedString.length > 1) {
                              setState(() {
                                notes[currentNoteIndex].name =
                                    splittedString[0] + ' ' + splittedString[1];
                                notes[currentNoteIndex].text = text;
                              });
                            } else {
                              setState(() {
                                notes[currentNoteIndex].text = text;
                              });
                            }
                            _save();
                          }
                        : null,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: MediaQuery.of(context).platformBrightness ==
                  Brightness.dark
              ? Colors.white
              : Colors
                  .black, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.only(top: 50),
            children: <Widget>[
              DrawerHeader(
                child: Text('Notes',
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 80,
                            color: MediaQuery.of(context).platformBrightness !=
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black))),
              ),
              SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                        itemCount: notes.length,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return ListTile(
                            tileColor:
                                currentNoteIndex == index ? Colors.grey : null,
                            title: Text(notes[index].name,
                                style: TextStyle(
                                    fontSize: 30,
                                    color: currentNoteIndex == index
                                        ? null
                                        : Colors.grey)),
                            onTap: () {
                              currentNoteIndex = index;
                              textController.text =
                                  notes[currentNoteIndex].text;
                              Navigator.pop(context);
                            },
                          );
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: MediaQuery.of(context).platformBrightness ==
                  Brightness.dark
              ? Colors.white
              : Colors
                  .black, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.only(top: 50),
            children: <Widget>[
              DrawerHeader(
                child: Text('Font',
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 80,
                            color: MediaQuery.of(context).platformBrightness !=
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black))),
              ),
              Slider(
                value: _currentSliderValue,
                max: 80,
                min: 20,
                divisions: 4,
                label: getSliderLabel(),
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                    _save();
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
