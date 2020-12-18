import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';
import 'package:safe_women/screen/home_screen.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _pages = <PageModel>[
      PageModel(
        title: Text(
          "Women Security App",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.04),
        ),
        color: Colors.grey[900],
        heroImagePath: 'icons/wom.png',
        iconImagePath: 'icons/female.png',
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: Text(
            "She is a Woman, a Mother, a Daughter, a Wife and a Sister. It's our firm duty to protect women of our society.\n\n Hence, we have developed this app to send alert to our loved ones in case of emergency, harassment etc.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white60,
                fontSize: MediaQuery.of(context).size.height * 0.02),
          ),
        ),
      ),
      PageModel(
          title: Text(
            "Shake to Alert",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.04),
          ),
          color: Colors.grey[800],
          heroImagePath: 'icons/sh.png',
          heroImageColor: Colors.white,
          iconImagePath: 'icons/female.png',
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Text(
              "Shake your Device to Alert your loved ones in no time and be safe!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: MediaQuery.of(context).size.height * 0.02),
            ),
          )),
      PageModel(
          title: Text(
            "Sharing is Caring",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.04),
          ),
          color: Colors.grey[700],
          heroImagePath: 'icons/share1.png',
          iconImagePath: 'icons/female.png',
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Text(
              "Share the app with other females around you for betterment of our society!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white60,
                  fontSize: MediaQuery.of(context).size.height * 0.02),
            ),
          )),
    ];
    return Scaffold(
      body: FancyOnBoarding(
        doneButtonText: "Done",
        doneButtonTextStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.02,
            fontWeight: FontWeight.bold),
        skipButtonText: "Skip",
        pageList: _pages,
        onDoneButtonPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false),
        onSkipButtonPressed: () => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false),
      ),
    );
  }
}
