import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/utils/text_theme_config.dart';

class AdminCaseDetailsEnrolledPage extends StatefulWidget {
  final Case caseInfo;

  const AdminCaseDetailsEnrolledPage({Key? key, required this.caseInfo}) : super(key: key);

  @override
  _AdminCaseDetailsEnrolledPageState createState() => _AdminCaseDetailsEnrolledPageState();
}

class _AdminCaseDetailsEnrolledPageState extends State<AdminCaseDetailsEnrolledPage> {
  List<User> enrolledUsers = [];
  late int caseId; // Variable to store the case ID
  bool _isLoading = false; // Loading state for API operations

  @override
  void initState() {
    super.initState();
    caseId = widget.caseInfo.id!;
    _loadEnrolledUsers();
  }

  Future<void> _loadEnrolledUsers() async {
    try {
      setState(() {
        _isLoading = true;
      });
      List<User> users = await APIService.getUsersByCase(caseId);
      setState(() {
        enrolledUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Failed to load enrolled users: $e');
      // Handle error as needed
    }
  }

  Future<void> _removeUserFromCase(int userId) async {
    try {
      await APIService.removeUserFromCase(caseId, userId: userId);
      // Refresh enrolled users list after removal
      await _loadEnrolledUsers();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Case Details - Admin View'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Case Name: ${widget.caseInfo.name}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Company Type: ${widget.caseInfo.companyType ?? 'N/A'}'),
                  SizedBox(height: 8),
                  Text('Industry: ${widget.caseInfo.industry ?? 'N/A'}'),
                  SizedBox(height: 8),
                  Text('ID: ${widget.caseInfo.id ?? 'N/A'}'),
                ],
              ),
            ),

            // Enrolled Users List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enrolled Users:',
                    style: MyTextStyles.smallHeading,
                  ),
                  SizedBox(height: 8),
                  enrolledUsers.isEmpty
                      ? Center(child: Text('No users are enrolled'))
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: enrolledUsers.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.person),
                          title: Text(enrolledUsers[index].username),
                          subtitle: Text(enrolledUsers[index].email),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () => _removeUserFromCase(enrolledUsers[index].id!),
                          ),
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
