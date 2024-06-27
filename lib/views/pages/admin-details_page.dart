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
import '../../utils/text_theme_config.dart';

class AdminDetailsPage extends ConsumerStatefulWidget {
  final User? userInfo;
  final Case? caseInfo;

  const AdminDetailsPage({Key? key, this.userInfo, this.caseInfo}) : super(key: key);

  @override
  _AdminDetailsPageState createState() => _AdminDetailsPageState();
}

class _AdminDetailsPageState extends ConsumerState<AdminDetailsPage> {
  List<Case> userCases = [];
  List<User> caseUsers = [];

  @override
  void initState() {
    super.initState();
    if (widget.userInfo != null) {
      _fetchCasesByUser(widget.userInfo!.id);
    } else if (widget.caseInfo != null) {
      _fetchUsersByCase(widget.caseInfo!.id!);
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
    if (widget.userInfo != null) {
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
        title: Text('ADMIN PANEL'),
        centerTitle: true,
      ),
      body: caseState.isLoading
          ? Center(child: CircularProgressIndicator())
          : caseState.errorMessage != null
          ? Center(child: Text(caseState.errorMessage!))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    '${widget.userInfo?.username} ist in ${userCases.length} ${userCases.length == 1 ? "Fall" : "Fällen"} eingeschrieben',
                    style: MyTextStyles.smallHeading,
                  ),
                ],
              ),
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
        title: Text('ADMIN PANEL'),
        centerTitle: true,
      ),
      body: userState.isLoading
          ? Center(child: CircularProgressIndicator())
          : userState.errorMessage != null
          ? Center(child: Text(userState.errorMessage!))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Text(
                    'In ${widget.caseInfo?.name} ${caseUsers.length == 1 ? "ist" : "sind"} ${caseUsers.length} ${caseUsers.length == 1 ? "Person" : "Personen"} eingeschrieben',
                    style: MyTextStyles.smallHeading,
                  ),
                ],
              ),
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
                  onGetCasesByUser: (userItem) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminDetailsPage(userInfo: caseUsers[index]),//Todo: Change to userItem
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

  void _removeUserFromCase(BuildContext context, int userId, int caseId) async {
    try {
      await APIService.removeUserFromCase(caseId, userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User removed from case successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Update user list after successful removal
      _fetchUsersByCase(caseId);
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
