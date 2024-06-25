import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/utils/user_state.dart';
import 'package:mobile_anw/utils/case_notifier.dart';
import 'package:mobile_anw/utils/user_notifier.dart';
import 'package:mobile_anw/views/widgets/admin-user_item.dart';
import 'package:mobile_anw/views/widgets/admin-case_item.dart';

class AdminDetailsPage extends ConsumerStatefulWidget {
  final int? userId;
  final int? caseId;

  const AdminDetailsPage({Key? key, this.userId, this.caseId}) : super(key: key);

  @override
  _AdminDetailsPageState createState() => _AdminDetailsPageState();
}

class _AdminDetailsPageState extends ConsumerState<AdminDetailsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      ref.read(caseProvider.notifier).getCasesByUser(widget.userId!);
    } else if (widget.caseId != null) {
      ref.read(userProvider.notifier).getUsersByCase(widget.caseId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId != null) {
      return _buildCasesForUser(context);
    } else if (widget.caseId != null) {
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
              'User is involved in ${caseState.userCases.length} cases',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: caseState.userCases.length,
              itemBuilder: (context, index) {
                final caseItem = caseState.userCases[index];
                return AdminCaseItem(
                  caseItem: caseItem,
                  onDelete: () {
                    // Implement case deletion logic here
                  },
                  onGetUsersByCase: (caseId) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminDetailsPage(caseId: caseId),
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
              'Case involves ${userState.caseUsers.length} users',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userState.caseUsers.length,
              itemBuilder: (context, index) {
                final userItem = userState.caseUsers[index];
                return AdminUserItem(
                  user: userItem,
                  onDeleteUser: (userId) {
                    _removeUserFromCase(context, userId, widget.caseId!);
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
      ref.read(userProvider.notifier).removeUserFromCase(caseId, userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User removed from case successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Update user list after successful removal
      ref.read(userProvider.notifier).getUsersByCase(caseId);
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
