import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/sections/category_section.dart';
import 'package:mobile_anw/views/widgets/sections/suggestions_section.dart';
import 'package:mobile_anw/views/widgets/sections/recent_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CategorySection(),
              SuggestionsSection(),
              RecentSection(),
              const Text(
                'Home',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontFamily: 'PTSerif',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}