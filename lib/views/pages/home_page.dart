import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/sections/category_section.dart';
import 'package:mobile_anw/views/widgets/sections/suggestions_section.dart';
import 'package:mobile_anw/views/widgets/sections/recent_section.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _logout() {
    APIService.logout();
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JUSTICASE'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
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