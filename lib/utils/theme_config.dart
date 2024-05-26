import 'package:flutter/material.dart';

class ThemeConfig {
  // Colors for theme
  static Color primary = Colors.white;
  static Color secondary = Colors.black;
  static Color accent1 = Colors.blue;

  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: primary,
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      elevation: 0,
      toolbarTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
        color: accent1,
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'PTSerif',
        fontSize: 24.0,
        fontWeight: FontWeight.w800,
        color: secondary,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: const IconThemeData(size: 40),
      unselectedIconTheme: const IconThemeData(size: 40),
      selectedItemColor: secondary,
      unselectedItemColor: Colors.grey[500],
    ),
    textTheme: const TextTheme(/*
      labelLarge: TextStyle( // Changed from headlineLarge to headline6
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
        color: Colors.yellow,
      ),
      labelMedium: TextStyle( // Changed from displayMedium to subtitle1
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      labelSmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: Colors.purple,
      ),*/
    ),
    // Todo: colorScheme missing?
  );
}
