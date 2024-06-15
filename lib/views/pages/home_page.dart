import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/sections/category_section.dart';
import 'package:mobile_anw/views/widgets/sections/suggestions_section.dart';
import 'package:mobile_anw/views/widgets/sections/recent_section.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/views/widgets/texts/headings/large_heading.dart';
import 'package:mobile_anw/views/widgets/texts/headings/middle_heading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _cases = [];
  bool _isLoading = true;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _fetchCases();
    _fetchUsername();
  }

  void _fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    setState(() {
      _username = username ?? '';
    });
  }

  void _fetchCases() async {
    try {
      List<Map<String, dynamic>> cases = await APIService.getAllCases();
      setState(() {
        _cases = cases;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Abrufen der Fälle: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CategorySection(),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: MiddleHeading(
                      text: 'Wilkommen zurück $_username',
                    ),
                  ),
              ),
              SuggestionsSection(cases: _cases),
              RecentSection(cases: _cases),
            ],
          ),
        ),
      ),
    );
  }
}
