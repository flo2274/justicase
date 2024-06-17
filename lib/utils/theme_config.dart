import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class ThemeConfig {
  // Farben für das Theme
  static const Color background = Color(0xFFF1F1F3); // Leicht dunkleres Weiß
  static Color primary = Colors.white;
  static Color blueAccent = Colors.blue; // Elegantes Dunkelblau
  static Color blackAccent = Colors.black;
  static Color lightGreyAccent = Color(0xFFA2A1A1);
  static Color darkGreyAccent = Color(0xFF5E5E5E);
  static Color yellowAccent = Colors.yellow;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF5E5E5E);
  static const Color? textBlueAccent = Colors.blue;

  static ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF6E0F53),
    scaffoldBackgroundColor: background, // Haupthintergrundfarbe
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      elevation: 0,
      iconTheme: IconThemeData(color: blackAccent),
      titleTextStyle: GoogleFonts.ptSerif(
        textStyle: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
          color: textBlueAccent,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(size: 35),
      unselectedIconTheme: IconThemeData(size: 35),
      selectedItemColor: null,
      unselectedItemColor: null,
    ),
    textTheme: const TextTheme(
      /*titleLarge: TextStyle( // Changed from headlineLarge to headline6
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: textBlueAccent,
      ),
      titleSmall: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
        color: textSecondary,
      ),*/
      bodyMedium: TextStyle( // This is the default text style for DropdownMenuItem
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      //HeadlineMedium is Text of Dropdown
      headlineMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: textPrimary),
      //Login Title

    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: textSecondary), // Hinweisfarbe für Textfelder
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
