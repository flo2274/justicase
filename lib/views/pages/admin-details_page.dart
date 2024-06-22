import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/utils/case_state.dart';
import 'package:mobile_anw/utils/user_state.dart';

import '../../utils/case_notifier.dart';
import '../../utils/user_notifier.dart';

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
      ref.read(userProvider.notifier).getUsersByCase(widget.caseId!);
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
          : ListView.builder(
        itemCount: caseState.userCases.length,
        itemBuilder: (context, index) {
          final caseItem = caseState.userCases[index];
          return ListTile(
            title: Text(caseItem.name!),
            subtitle: Text(caseItem.companyType!),
            onTap: () {
              // Handle case item tap
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminDetailsPage(
                    caseId: caseItem.id,
                  ),
                ),
              );
            },
          );
        },
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
          : ListView.builder(
        itemCount: userState.caseUsers.length, // Anpassung hier
        itemBuilder: (context, index) {
          final userItem = userState.caseUsers[index]; // Anpassung hier
          return ListTile(
            title: Text(userItem.username),
            subtitle: Text(userItem.email),
          );
        },
      ),
    );
  }
}
