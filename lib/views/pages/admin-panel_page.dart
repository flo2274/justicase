import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/views/widgets/case_item.dart';
import '../../utils/case_notifier.dart';
import '../../utils/case_state.dart';
import '../../utils/user_notifier.dart';
import '../../utils/user_state.dart';
import '../widgets/admin-user_item.dart';
import 'admin-details_page.dart';
import 'package:go_router/go_router.dart';


class AdminPanelPage extends ConsumerStatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends ConsumerState<AdminPanelPage> {

  @override
  void initState() {
    super.initState();
    ref.read(caseProvider.notifier).getAllCases(); // Trigger fetching all cases on widget initialization
    ref.read(userProvider.notifier).getAllUsers(); // Trigger fetching all users on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    final caseState = ref.watch(caseProvider);
    final userState = ref.watch(userProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Panel'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Cases'),
            ],
          ),
        ),
        body: userState.isLoading || caseState.isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
          children: [
            _buildUsersTab(context, userState),
            _buildCasesTab(context, caseState),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersTab(BuildContext context, UserState userState) {
    return SingleChildScrollView(
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
          _buildUsersList(context, userState),
        ],
      ),
    );
  }

  Widget _buildUsersList(BuildContext context, UserState userState) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: userState.allUsers.length,
      itemBuilder: (context, index) {
        final user = userState.allUsers[index];
        return AdminUserItem(
          user: user,
          onDeleteUser: _deleteUser,
          onGetCasesByUser: _getCasesByUser,
        );
      },
    );
  }

  void _deleteUser(int userId) async {
    try {
      await ref.read(userProvider.notifier).deleteUser(userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _getCasesByUser(int userId) async {
    try {
      await ref.read(caseProvider.notifier).getCasesByUser(userId);
      // Navigate to a new page to show cases for this user
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminDetailsPage(
            userId: userId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch cases for user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildCasesTab(BuildContext context, CaseState caseState) {
    return SingleChildScrollView(
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
          _buildCasesList(context, caseState),
        ],
      ),
    );
  }

  Widget _buildCasesList(BuildContext context, CaseState caseState) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: caseState.allCases.length,
      itemBuilder: (context, index) {
        final caseInfo = caseState.allCases[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminDetailsPage(
                  caseId: caseInfo.id,
                ),
              ),
            );
          },
          child: CaseItem(
            caseItem: caseInfo,
            onDelete: () => _deleteCase(caseInfo.id!),
          ),
        );
      },
    );
  }


  void _deleteCase(int caseId) async {
    /*try {
      await APIService.deleteCase(caseId);
      ref.read(caseProvider.notifier).refreshAllCases();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Case deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete case: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }*/
  }
}
