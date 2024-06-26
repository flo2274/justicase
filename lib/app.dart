import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_anw/views/pages/auth/login_page.dart'; // Updated import to reflect the correct path
import 'utils/configs/theme_config.dart'; // Updated import to reflect the correct path
import 'package:mobile_anw/views/pages/case/case_page.dart';
import 'package:mobile_anw/views/pages/case/case-details_page.dart';
import 'package:mobile_anw/views/pages/home/home_page.dart';
import 'package:mobile_anw/views/pages/search/search_page.dart';
import 'package:mobile_anw/views/pages/scaffold_with_nested_navigation.dart';
import 'package:mobile_anw/utils/router.dart';
import 'package:mobile_anw/utils/configs/theme_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
