import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/configs/theme_config.dart';
import 'package:mobile_anw/utils/router.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.lightTheme.copyWith(
        textTheme: GoogleFonts.sourceSansProTextTheme(
          ThemeConfig.lightTheme.textTheme,
        ),
      ),
    );
  }
}
