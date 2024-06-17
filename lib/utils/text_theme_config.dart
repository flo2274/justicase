import 'package:flutter/material.dart';

class MyTextStyles {

  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF5E5E5E);
  static const Color? textBlueAccent = Colors.blue;

  static const TextStyle largeHeading = TextStyle( // Changed from headlineLarge to headline6
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle middleHeading = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: textBlueAccent,
  );

  static const TextStyle smallHeading = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: textSecondary,
  );

  static const TextStyle authLargeHeading = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    color: textSecondary,
    fontFamily: 'ptSerif',
  );

  static const TextStyle authWelcome1Text = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    fontFamily: 'Lato',
  );

  static const TextStyle authWelcome2Text = TextStyle(
    fontSize: 26.0,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    fontFamily: 'Lato',
  );

  static const TextStyle authAccentBlue2Heading = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: textBlueAccent,
    fontFamily: 'Oswald',
  );

  static const TextStyle authSmallHeading = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: textSecondary,
    fontFamily: 'Oswald',
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );
}