// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'journal_page.dart';

class Hwyd extends StatefulWidget {
  const Hwyd({Key? key}) : super(key: key);

  @override
  _HwydState createState() => _HwydState();
}

class _HwydState extends State<Hwyd> {
  static const String _onBoardKey = 'onboard';
  bool showOnboard = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardStatus();
  }

  _checkOnboardStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      showOnboard =
          jsonDecode(prefs.getString(_onBoardKey) ?? json.encode(true));
    });
  }

  _disableOnboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_onBoardKey, json.encode(false));
  }

  @override
  Widget build(BuildContext context) {
    return showOnboard == true
        ? _buildIntroductionScreen()
        : const JournalPage();
  }

  Future<void> _launchPrivacyPolicyUrl() async {
    Uri privacyPolicyUrl =
        Uri.parse('https://github.com/omartoutounji/hwyd/wiki/Privacy-Policy');
    if (!await launchUrl(privacyPolicyUrl)) {
      throw Exception('Could not launch $privacyPolicyUrl');
    }
  }

  Widget _buildIntroductionScreen() {
    return CupertinoOnboarding(
        onPressedOnLastPage: () {
          _disableOnboard();
          Navigator.pushReplacementNamed(context, '/journal');
        },
        widgetAboveBottomButton: CupertinoButton(
          child: Text(
            'Privacy Policy',
            style: TextStyle(
              color: CupertinoColors.systemTeal.resolveFrom(context),
            ),
          ),
          onPressed: () => _launchPrivacyPolicyUrl(),
        ),
        pages: [
          WhatsNewPage(title: const Text("Welcome to hwyd"), features: const [
            WhatsNewFeature(
                title: Text("The comfort of privacy"),
                description: Text(
                    "hwyd is built from the ground up to be private and secure. We don’t know what journals you enter or what you type. Heck, we don't — and will never know a damn thing about you! Don't believe us? Check out our privacy policy below."),
                icon: Icon(Icons.lock)),
            WhatsNewFeature(
                title: Text("Clean and calm"),
                description: Text(
                    "Clean and calm, hwyd shapes itself to how you use it. It's a journal that doesn’t just meet your needs — it anticipates them."),
                icon: Icon(Icons.self_improvement)),
            WhatsNewFeature(
                title: Text("Space for the different sides of you"),
                description: Text(
                    "Effortlessly organize everything you journal — work, study, hobbies — all in one place with Dresser."),
                icon: Icon(Icons.favorite))
          ])
        ]);
  }
}
