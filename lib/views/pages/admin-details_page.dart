import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/utils/user_state.dart';
import 'package:mobile_anw/utils/case_notifier.dart';
import 'package:mobile_anw/utils/user_notifier.dart';
import 'package:mobile_anw/views/widgets/admin-user_item.dart';
import 'package:mobile_anw/views/widgets/admin-case_item.dart';

import '../../models/case.dart';
import '../../models/user.dart';

class AdminDetailsPage extends ConsumerStatefulWidget {
  final int? userId;
  final Case? caseInfo;

  const AdminDetailsPage({Key? key, this.userId, this.caseInfo}) : super(key: key);

  @override
  _AdminDetailsPageState createState() => _AdminDetailsPageState();
}

class _AdminDetailsPageState extends ConsumerState<AdminDetailsPage> {
  List<Case> userCases = [];
  List<User> caseUsers = [];
  String? caseName;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      // Fetch cases for user directly using API
      _fetchCasesByUser(widget.userId!);
    } else if (widget.caseInfo != null) {
      // Fetch users for case directly using API
      _fetchUsersByCase(widget.caseInfo!.id!);
      caseName = widget.caseInfo!.name;
    }
  }

  Future<void> _fetchCasesByUser(int userId) async {
    try {
      List<Case> cases = await APIService.getCasesByUser(userId: userId);
      setState(() {
        userCases = cases;
      });
    } catch (e) {
      print('Failed to load cases: $e');
      // Handle error as needed
    }
  }

  Future<void> _fetchUsersByCase(int caseId) async {
    try {
      List<User> users = await APIService.getUsersByCase(caseId);
      setState(() {
        caseUsers = users;
      });
    } catch (e) {
      print('Failed to load users: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId != null) {
      return _buildCasesForUser(context);
    } else if (widget.caseInfo != null) {
      return _buildUsersInCase(context);
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Admin Details'),
        ),
        body: Center(
          child: Text('No data available'),
        ),
      );
    }
  }

  Widget _buildCasesForUser(BuildContext context) {
    final caseState = ref.watch(caseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cases for User'),
      ),
      body: caseState.isLoading
          ? Center(child: CircularProgressIndicator())
          : caseState.errorMessage != null
          ? Center(child: Text(caseState.errorMessage!))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Cases for user',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userCases.length,
              itemBuilder: (context, index) {
                final caseItem = userCases[index];
                return AdminCaseItem(
                  caseItem: caseItem,
                  onDelete: () {
                    // Implement case deletion logic here
                  },
                  onGetUsersByCase: (caseItem) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminDetailsPage(caseInfo: caseItem),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersInCase(BuildContext context) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Users in Case'),
      ),
      body: userState.isLoading
          ? Center(child: CircularProgressIndicator())
          : userState.errorMessage != null
          ? Center(child: Text(userState.errorMessage!))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Case involves ${caseUsers.length} users in $caseName',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: caseUsers.length,
              itemBuilder: (context, index) {
                final userItem = caseUsers[index];
                return AdminUserItem(
                  user: userItem,
                  onDeleteUser: (userId) {
                    _removeUserFromCase(context, userId, widget.caseInfo!.id!);
                  },
                  onGetCasesByUser: (userId) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminDetailsPage(userId: userId),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _removeUserFromCase(BuildContext context, int userId, int caseId) {
    try {
      APIService.removeUserFromCase(caseId, userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User removed from case successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Todo: check id and when necessary -> Update user list after successful removal
      APIService.getUsersByCase(caseId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to remove user from case: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
