import 'package:flutter/material.dart';

class ThemeConfig {
  // Colors for theme
  static Color primary = Colors.white;
  static Color secondary = Colors.black;
  static Color accent = Colors.blue;

  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: primary,
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      elevation: 0,
      toolbarTextStyle: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
        color: accent,
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'PTSerif',
        fontSize: 24.0,
        fontWeight: FontWeight.w800,
        color: secondary,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(size: 40),
      unselectedIconTheme: IconThemeData(size: 40),
      selectedItemColor: secondary,
      unselectedItemColor: Colors.grey[500],
    ),
    // Todo: colorScheme missing?
  );
}
