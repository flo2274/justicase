import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/utils/configs/text_theme_config.dart';
import 'package:mobile_anw/state/notifiers/case_notifier.dart';
import 'package:mobile_anw/state/models/case_state.dart';
import 'package:mobile_anw/state/notifiers/user_notifier.dart';
import 'package:mobile_anw/state/models/user_state.dart';
import '../../../data/constants/case_data.dart';
import '../../items/admin/admin-case_item.dart';
import '../../items/admin/admin-user_item.dart';
import 'admin-details_page.dart';

class AdminPanelPage extends ConsumerStatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends ConsumerState<AdminPanelPage> {
  String selectedFilter = 'Alle';

  @override
  void initState() {
    super.initState();
    ref.read(caseProvider.notifier).fetchAllCases(); // Trigger fetching all cases on widget initialization
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
          title: const Text('ADMIN PANEL'),
          centerTitle: true,
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
              'Es gibt insgesamt ${userState.allUsers.length} ${userState.allUsers.length == 1 ? "Person" : "Personen"}',
              style: TextThemeConfig.smallHeading,
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
          onGetCasesByUser: (caseInfo) => _getCasesByUser(user),
        );
      },
    );
  }

  void _deleteUser(int userId) async {
    try {
      await APIService.deleteUser(userId);
      ref.read(userProvider.notifier).refreshAllUsers(); // Refresh user list after deletion
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

  Widget _buildCasesTab(BuildContext context, CaseState caseState) {
    final filteredCases = _filteredCases(caseState);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8.0),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child:
          Wrap(
              spacing: 8.0,
              children: CaseData.filterOptions.map((option) {
                return ChoiceChip(
                  label: Text(
                    option,
                    style: TextStyle(color: Colors.white),
                  ),
                  selected: selectedFilter == option,
                  selectedColor: Colors.blue,
                  onSelected: (selected) {
                    setState(() {
                      selectedFilter = option;
                    });
                  },
                );
              }).toList(),
            ),
      ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Es gibt insgesamt ${filteredCases.length} ${filteredCases.length == 1 ? "Fall" : "Fälle"}',
              style: TextThemeConfig.smallHeading,
            ),
          ),
          _buildCasesList(context, filteredCases),
        ],
      ),
    );
  }

  List<Case> _filteredCases(CaseState caseState) {
    return caseState.allCases.where((caseItem) {
      switch (selectedFilter) {
        case 'Vollständig':
          return caseItem.userCount >= 50;
        case 'Leer':
          return caseItem.userCount == 0;
        default:
          return true;
      }
    }).toList();
  }

  Widget _buildCasesList(BuildContext context, List<Case> filteredCases) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: filteredCases.length,
      itemBuilder: (context, index) {
        final caseInfo = filteredCases[index];
        return FutureBuilder<int>(
          future: APIService.getEnrolledUsersCount(caseInfo.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Update the caseItem.userCount with the enrolled users count
              caseInfo.userCount = snapshot.data ?? 0;
              return AdminCaseItem(
                caseItem: caseInfo,
                onDelete: () => _deleteCase(caseInfo.id!),
                onGetUsersByCase: (caseItem) => _getUsersByCase(caseInfo),
              );
            }
          },
        );
      },
    );
  }

  void _getUsersByCase(Case myCase) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminDetailsPage(
          myCase: myCase,
        ),
      ),
    );
  }

  void _getCasesByUser(User myUser) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminDetailsPage(
          myUser: myUser,
        ),
      ),
    );
  }

  void _deleteCase(int caseId) async {
    try {
      await ref.read(caseProvider.notifier).deleteCase(caseId);
      await ref.read(caseProvider.notifier).fetchAllCases(); // Refresh case list after deletion
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
    }
  }
}
