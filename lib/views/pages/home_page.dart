import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_anw/models/case.dart'; // Adjust import path as per your project structure
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/utils/text_theme_config.dart';
import 'package:mobile_anw/views/widgets/sections/category_section.dart';
import 'package:mobile_anw/views/widgets/sections/suggestions_section.dart';
import 'package:mobile_anw/views/widgets/sections/recent_section.dart';
import '../../services/api_service.dart';
import '../../utils/case_notifier.dart'; // Adjust import path as per your project structure
import '../../utils/case_state.dart'; // Adjust import path as per your project structure

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _username = '';
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    ref.read(caseProvider.notifier).getAllCases(); // Trigger fetching all cases on widget initialization
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _isAdmin = prefs.getString('role') == 'admin';
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
    final caseState = ref.watch(caseProvider);

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
      body: caseState.isLoading
          ? Center(child: CircularProgressIndicator())
          : caseState.errorMessage != null
          ? Center(
        child: Text(
          'Fehler beim Abrufen der Fälle: ${caseState.errorMessage}',
        ),
      )
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
            SuggestionsSection(cases: caseState.allCases),
            RecentSection(cases: caseState.allCases),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
