import 'package:flutter/material.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/models/case.dart'; // Assuming Case class is defined in case.dart
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/views/widgets/user_item.dart'; // Assuming UserItem is a widget for displaying users
import 'package:mobile_anw/views/widgets/case_item.dart'; // Assuming CaseItem is a widget for displaying cases

import 'admin-case-details-enrolled-page.dart'; // New: Import CaseDetailsPage

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<User> _users = [];
  List<Case> _cases = [];

  bool _isLoadingUsers = true;
  bool _isLoadingCases = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize TabController
    _fetchUsers();
    _fetchCases();
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  void _fetchUsers() async {
    try {
      List<User> users = await APIService.getUsers();
      setState(() {
        _users = users;
        _isLoadingUsers = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingUsers = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch users: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _fetchCases() async {
    try {
      List<Case> cases = await APIService.getAllCases();
      setState(() {
        _cases = cases;
        _isLoadingCases = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCases = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch cases: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _addUserToCase(int userId, int caseId) async {
    try {
      await APIService.addUserToCase(caseId, userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User added to case successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add user to case: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeUserFromCase(int userId, int caseId) async {
    try {
      await APIService.removeUserFromCase(caseId, userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User removed from case successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove user from case: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToCaseDetails(Case caseInfo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminCaseDetailsEnrolledPage(caseInfo: caseInfo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Panel'),
          bottom: TabBar(
            controller: _tabController, // Bind TabController to TabBar
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Cases'),
            ],
          ),
        ),
        body: _isLoadingUsers || _isLoadingCases
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
          controller: _tabController, // Bind TabController to TabBarView
          children: [
            // Users Tab
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Users:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _users.isEmpty
                      ? Center(child: Text('No users found'))
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      return UserItem(
                        user: _users[index],
                        onAddToCase: (caseId) =>
                            _addUserToCase(_users[index].id, caseId),
                        onRemoveFromCase: (caseId) =>
                            _removeUserFromCase(_users[index].id, caseId),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Cases Tab
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Cases:',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _cases.isEmpty
                      ? Center(child: Text('No cases found'))
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _cases.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _navigateToCaseDetails(_cases[index]), // Navigate to case details
                        child: CaseItem(
                          caseItem: _cases[index],
                          onDelete: () => null,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
