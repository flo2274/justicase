import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class ThemeConfig {
  static const Color background = Color(0xFFF1F1F3);
  static Color primary = Colors.white;
  static Color blueAccent = Colors.blue;
  static Color blackAccent = Colors.black;
  static Color lightGreyAccent = const Color(0xFFA2A1A1);
  static Color darkGreyAccent = const Color(0xFF5E5E5E);
  static Color yellowAccent = Colors.yellow;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF5E5E5E);
  static const Color textBlueAccent = Colors.blue;

  static ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF6E0F53),
    scaffoldBackgroundColor: background,
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
      bodyMedium: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: textPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: const TextStyle(color: textSecondary),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: lightGreyAccent),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightGreyAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightGreyAccent),
      ),
      filled: true,
      fillColor: background,
    ),

    dialogTheme: DialogTheme(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),

    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: lightGreyAccent,
      secondary: Colors.white,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: const Color(0xFFE308A7),
      onSurface: textPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
