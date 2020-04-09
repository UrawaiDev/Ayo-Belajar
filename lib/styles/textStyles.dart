import 'package:flutter/material.dart';

Color defaultButtonColor = Color(0xff81a8ff);

const double superLargeFont = 50;
const double largeFont = 26;
const double mediumFont = 22;
const double smallFont = 16;

const String defaultFont = 'Quicksand';

TextStyle questionsStyle = TextStyle(
  fontSize: superLargeFont,
  fontWeight: FontWeight.bold,
  fontFamily: defaultFont,
);

TextStyle topScore = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  fontFamily: defaultFont,
  color: Colors.lightBlue,
);

TextStyle answerSmallStyle = TextStyle(
  fontSize: mediumFont,
  fontWeight: FontWeight.bold,
  fontFamily: defaultFont,
  color: Colors.white,
);

TextStyle questionsSmallStyle = TextStyle(
  fontSize: mediumFont,
  fontWeight: FontWeight.bold,
  fontFamily: defaultFont,
);

TextStyle answerStyle = TextStyle(
  fontSize: superLargeFont,
  fontWeight: FontWeight.bold,
  fontFamily: defaultFont,
);

TextStyle playerStyle = TextStyle(
  fontSize: smallFont,
  fontWeight: FontWeight.bold,
  fontFamily: defaultFont,
  //color: Colors.green[300]
);

TextStyle scoreStyle = TextStyle(
    fontSize: largeFont,
    fontWeight: FontWeight.bold,
    fontFamily: defaultFont,
    color: Colors.green[300]);

TextStyle headerStyle = TextStyle(
    fontSize: superLargeFont,
    fontWeight: FontWeight.bold,
    fontFamily: defaultFont,
    color: Colors.green[300]);
