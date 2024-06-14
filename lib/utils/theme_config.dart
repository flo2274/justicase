import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  // Farben für das Theme
  static Color background = Color(0xFFF2F2F8); // Leicht dunkleres Weiß
  static Color primary = Colors.white;
  static Color blueAccent = Color(0xFF003CFF); // Elegantes Dunkelblau
  static Color blackAccent = Colors.black;
  static Color lightGreyAccent = Color(0xFFA2A1A1);
  static Color darkGreyAccent = Color(0xFF5E5E5E);
  static Color yellowAccent = Colors.yellow;
  static Color textPrimary = Colors.black;
  static Color? textSecondary = Colors.grey[700];

  static ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF6E0F53),
    scaffoldBackgroundColor: background, // Haupthintergrundfarbe
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      elevation: 0,
      iconTheme: IconThemeData(color: blackAccent),
      titleTextStyle: GoogleFonts.ptSerif(
        textStyle: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(size: 35),
      unselectedIconTheme: IconThemeData(size: 35),
      selectedItemColor: null,
      unselectedItemColor: null,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: textSecondary), // Hinweisfarbe für Textfelder
      border: OutlineInputBorder(
        borderSide: BorderSide(color: lightGreyAccent), // Umrandungsfarbe für Textfelder (Gelb)
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightGreyAccent), // Umrandungsfarbe im Fokus
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightGreyAccent), // Umrandungsfarbe im Standardzustand
      ),
      filled: true,
      fillColor: background, // Hintergrundfarbe für Textfelder
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: lightGreyAccent, // Für Dinge wie Umrandung bei der Searchbar
      secondary: Colors.white,
      surface: Colors.white, // Füllt Vorschläge bei der Searchbar
      onPrimary: Colors.white, // Füllt Schaltfläche bei Create Case
      onSecondary: Color(0xFFE308A7),
      onSurface: textPrimary, // Schriftfarbe bei Homepage-Case-Elementen
    ),
  );
}



/*
class ThemeConfig {
  // Colors for theme
  static Color primary = ;
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
}*/
