import 'package:flutter/material.dart';
import 'pages/case_page.dart';
import 'pages/forum_page.dart';
import 'pages/home_page.dart';
import 'pages/registration_page.dart';
import 'pages/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/register',
      routes: {
        '/homepage': (context) => const HomePage(),
        '/search': (context) => const SearchPage(),
        '/register': (context) => const RegistrationPage(),
        '/case': (context) => const CasePage(),
        '/forum': (context) => const ForumPage(),
      },
    );
  }
}

