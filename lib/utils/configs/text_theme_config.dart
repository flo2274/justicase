import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextThemeConfig {

  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF5E5E5E);
  static const Color textLightSecondary = Color(0xFF9D9D9D);
  static const Color? textBlueAccent = Colors.blue;

  static TextStyle largeHeading = GoogleFonts.barlow(
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle middleHeading1 = GoogleFonts.barlow(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: textBlueAccent,
  );

  static TextStyle middleHeading2 = GoogleFonts.barlow(
    fontSize: 24.0,
    fontWeight: FontWeight.w800,
    color: textBlueAccent,
  );

  static TextStyle smallHeading = GoogleFonts.barlow(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: textSecondary,
  );

  static TextStyle authLargeHeading = GoogleFonts.ptSerif(
    fontSize: 26.0,
    fontWeight: FontWeight.bold,
    color: textSecondary,
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

  static const TextStyle primaryBigCaseText = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle primaryLongCaseText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static const TextStyle secondaryLongCaseText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: textLightSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  static const TextStyle alertText = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.normal,
    color: Colors.red,
  );

  static const TextStyle infoText = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
}

