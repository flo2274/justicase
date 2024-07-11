import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/state/notifiers/case_notifier.dart';
import 'package:mobile_anw/state/notifiers/user_notifier.dart';
import '../../../models/case.dart';
import '../../../models/user.dart';
import '../../../utils/configs/text_theme_config.dart';
import '../../items/admin/admin-case_item.dart';
import '../../items/admin/admin-user_item.dart';

class AdminDetailsPage extends ConsumerStatefulWidget {
  final User? myUser;
  final Case? myCase;

  const AdminDetailsPage({super.key, this.myUser, this.myCase});

  @override
  _AdminDetailsPageState createState() => _AdminDetailsPageState();
}

class _AdminDetailsPageState extends ConsumerState<AdminDetailsPage> {
  List<Case> userCases = [];
  List<User> caseUsers = [];

  @override
  void initState() {
    super.initState();
    if (widget.myUser != null) {
      _fetchCasesByUser(widget.myUser!.id);
    } else if (widget.myCase != null) {
      _fetchUsersByCase(widget.myCase!.id!);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.myUser != null) {
      return _buildCasesForUser(context);
    } else if (widget.myCase != null) {
      return _buildUsersInCase(context);
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Details'),
        ),
        body: const Center(
          child: Text('No data available'),
        ),
      );
    }
  }

  Widget _buildCasesForUser(BuildContext context) {
    final caseState = ref.watch(caseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN PANEL'),
        centerTitle: true,
      ),
      body: caseState.isLoading
          ? const Center(child: CircularProgressIndicator())
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
                    '${widget.myUser?.username} ist in ${userCases.length} ${userCases.length == 1 ? "Fall" : "Fällen"} eingeschrieben',
                    style: TextThemeConfig.smallHeading,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userCases.length,
              itemBuilder: (context, index) {
                final myCase = userCases[index];
                return FutureBuilder<int>(
                  future: APIService.getEnrolledUsersCount(myCase.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      myCase.userCount = snapshot.data ?? 0;
                      return AdminCaseItem(
                        caseItem: myCase,
                        onDelete: () {
                          _deleteCase(myCase.id!);
                        },
                        onGetUsersByCase: (myCase) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminDetailsPage(myCase: myCase),
                            ),
                          );
                        },
                      );
                    }
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
        title: const Text('ADMIN PANEL'),
        centerTitle: true,
      ),
      body: userState.isLoading
          ? const Center(child: CircularProgressIndicator())
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
                    'In ${widget.myCase?.name} ${caseUsers.length == 1 ? "ist" : "sind"} ${caseUsers.length} ${caseUsers.length == 1 ? "Person" : "Personen"} eingeschrieben',
                    style: TextThemeConfig.smallHeading,
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
                    _deleteUser(userId);
                  },
                  onRemoveUserFromCase: (userId) {
                    _removeUserFromCase(context, widget.myCase!.id!, userId: userId);
                  },
                  onGetCasesByUser: (userItem) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminDetailsPage(myUser: caseUsers[index]),
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

  void _deleteUser(int userId) async {
    try {
      ref.read(userProvider.notifier).deleteUser(userId);
      ref.read(userProvider.notifier).refreshAllUsers();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Benutzer erfolgreich gelöscht'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Löschen des Benutzers: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeUserFromCase(BuildContext context, int caseId, {int? userId}) async {
    try {
      await APIService.removeUserFromCase(caseId, userId: userId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User removed from case successfully'),
          backgroundColor: Colors.green,
        ),
      );

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

  void _deleteCase(int caseId) async {
    try {
      await ref.read(caseProvider.notifier).deleteCase(caseId);
      await ref.read(caseProvider.notifier).fetchAllCases();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fall erfolgreich gelöscht'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Löschen des Falls: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
