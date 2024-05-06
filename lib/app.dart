import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_anw/views/pages/auth/login_page.dart';
import 'package:mobile_anw/utils/theme_config.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Justicase',
      theme: _buildThemeData(ThemeConfig.lightTheme),
      // darkTheme: _buildThemeData(ThemeConfig.darkTheme),
      home: Login(),
    );
  }

  ThemeData _buildThemeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
    );
  }
}
