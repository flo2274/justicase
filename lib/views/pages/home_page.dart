import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart'; // Import der Case-Klasse
import 'package:mobile_anw/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/utils/text_theme_config.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_anw/views/widgets/sections/category_section.dart';
import 'package:mobile_anw/views/widgets/sections/suggestions_section.dart';
import 'package:mobile_anw/views/widgets/sections/recent_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Case> _cases = [];
  bool _isLoading = true;
  String _username = '';
  bool _isAdmin = false; // New variable to check if user is admin

  @override
  void initState() {
    super.initState();
    _fetchCases();
    _fetchUsername();
    _checkAdminStatus(); // Check if user is admin
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
      List<Case> cases = await APIService.getAllCases();
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

  void _checkAdminStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');
    setState(() {
      _isAdmin = role == 'admin';
    });
  }

  void _logout() {
    APIService.logout();
    context.go('/login');
  }

  void _navigateToAdminPanel() {
    context.go('/home/adminPanel'); // Navigate to admin panel route
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JUSTICASE'),
        centerTitle: true,
        leading: _isAdmin // Show admin panel icon on the left if user is admin
            ? IconButton(
          icon: Icon(Icons.admin_panel_settings_outlined),
          onPressed: _navigateToAdminPanel,
          tooltip: 'Admin Panel',
        )
            : null,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            CategorySection(),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Willkommen zurück, $_username',
                  style: MyTextStyles.middleHeading,
                ),
              ),
            ),
            SuggestionsSection(cases: _cases),
            RecentSection(cases: _cases),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

