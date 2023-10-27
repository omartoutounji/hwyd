// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/Note.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  String greeting = "";
  List<Note> notes = [];
  int currentNoteIndex = 0;
  final Image logo = Image.asset('assets/hwyd_logo.png', width: 50);
  final textController = TextEditingController();
  final renameController = TextEditingController();
  double _currentSliderValue = 80;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isRenameTextFieldEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
    if (notes.isEmpty) {
      _createNewNote();
    }
    greeting = getRandomGreeting();
  }

  Note getNewNote() {
    return Note(getPrettyDate(), "");
  }

  String getPrettyDate() {
    return formatDate(
        DateTime.now(), [M, ' ', d, ' at ', HH, ':', nn, '.', ss]);
  }

  Future<void> _launchPrivacyPolicyUrl() async {
    Uri privacyPolicyUrl = Uri.parse(
        'https://github.com/omartoutounji/hwyd/tree/master/privacy-policy/hwyd-app-privacy-policy.pdf');
    if (!await launchUrl(privacyPolicyUrl)) {
      throw Exception('Could not launch $privacyPolicyUrl');
    }
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
    renameController.dispose();
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

  _deleteNote(index) async {
    Note backupCopy = notes[index];
    setState(() {
      notes.removeAt(index);
      if (notes.isEmpty) {
        _createNewNote();
      }
      currentNoteIndex = notes.length - 1;
      textController.text = notes[currentNoteIndex].text;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Note deleted forever'),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              notes.add(backupCopy);
              currentNoteIndex = notes.length - 1;
              textController.text = notes[currentNoteIndex].text;
            });
          }),
    ));
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
    final random = Random();
    return greetings[random.nextInt(greetings.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: IconButton(
                        onPressed: () =>
                            _scaffoldKey.currentState!.openDrawer(),
                        icon: const Icon(Icons.menu)),
                  ),
                  Expanded(
                    child: Text(
                      notes[currentNoteIndex].name,
                      style: getStyle(30).copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                      onPressed: notes[currentNoteIndex].text.isEmpty
                          ? null
                          : () => Share.share(notes[currentNoteIndex].text),
                      icon: const Icon(Icons.ios_share)),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                        onPressed: () => _deleteNote(currentNoteIndex),
                        icon: const Icon(Icons.delete_outline)),
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
                  style: getStyle(30),
                  textAlign: TextAlign.center,
                  onSubmitted: (text) {
                    setState(() {
                      notes[currentNoteIndex].text = text;
                    });
                    _save();
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _createNewNote();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                        backgroundColor:
                            MediaQuery.of(context).platformBrightness ==
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 60,
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
            padding: const EdgeInsets.only(top: 50),
            children: <Widget>[
              DrawerHeader(
                child: Text('Notes',
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 60,
                            color: MediaQuery.of(context).platformBrightness !=
                                    Brightness.dark
                                ? Colors.white
                                : Colors.black))),
              ),
              SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Column(
                  children: [
                    ListView.builder(
                        itemCount: notes.length,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final currentNote = notes[index];
                          return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                                color: Colors.red,
                                child:
                                    const Icon(Icons.delete_forever_outlined)),
                            onDismissed: (direction) {
                              // Remove the item from the data source.
                              setState(() {
                                _deleteNote(index);
                              });
                            },
                            child: ListTile(
                              tileColor: currentNoteIndex == index
                                  ? Colors.grey
                                  : null,
                              title: TextField(
                                onTap: () {
                                  setState(() {
                                    isRenameTextFieldEnabled = true;
                                  });
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(20)
                                ],
                                controller: renameController,
                                enabled: currentNoteIndex == index
                                    ? isRenameTextFieldEnabled
                                    : false,
                                showCursor: currentNoteIndex == index
                                    ? isRenameTextFieldEnabled
                                    : false,
                                autofocus: currentNoteIndex == index
                                    ? isRenameTextFieldEnabled
                                    : false,
                                onSubmitted: (value) {
                                  setState(() {
                                    currentNote.name = value;
                                    isRenameTextFieldEnabled = false;
                                  });
                                  renameController.clear();
                                  _save();
                                },
                                decoration: InputDecoration.collapsed(
                                    hintStyle: TextStyle(
                                        fontSize: 20,
                                        color: currentNoteIndex == index
                                            ? null
                                            : Colors.grey),
                                    hintText: currentNote.name,
                                    border: InputBorder.none),
                              ),
                              onTap: () {
                                setState(() {
                                  currentNoteIndex = index;
                                });
                                textController.text =
                                    notes[currentNoteIndex].text;
                                Navigator.pop(context);
                              },
                              trailing: IconButton(
                                  onPressed: currentNoteIndex == index
                                      ? () {
                                          setState(() {
                                            isRenameTextFieldEnabled = true;
                                          });
                                        }
                                      : null,
                                  icon: const Icon(
                                      Icons.drive_file_rename_outline)),
                            ),
                          );
                        }),
                    InkWell(
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(color: Colors.grey),
                      ),
                      onTap: () => _launchPrivacyPolicyUrl(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
