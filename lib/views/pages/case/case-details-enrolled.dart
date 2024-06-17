import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_anw/views/pages/case/case-details-enrolled.dart';
import 'package:mobile_anw/views/pages/case/case-details-forum.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/user.dart';

class CaseDetailsEnrolled extends StatefulWidget {
  final Case caseInfo;

  const CaseDetailsEnrolled({Key? key, required this.caseInfo}) : super(key: key);

  @override
  _CaseDetailsEnrolledState createState() => _CaseDetailsEnrolledState();
}

class _CaseDetailsEnrolledState extends State<CaseDetailsEnrolled> {
  List<User> enrolledUsers = [];
  late int caseId; // Variable to store the case ID
  bool isEnrolled = false; // Variable to track if current user is enrolled

  @override
  void initState() {
    super.initState();
    caseId = widget.caseInfo.id!;
    _loadEnrolledUsers();
  }

  Future<void> _loadEnrolledUsers() async {
    try {
      List<User> users = await APIService.getUsersByCase(caseId);
      setState(() {
        enrolledUsers = users;
      });
      await _checkEnrollmentStatus();
    } catch (e) {
      print('Failed to load enrolled users: $e');
      // Handle error as needed
    }
  }

  Future<void> _checkEnrollmentStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? currentUser = prefs.getString('username');

    setState(() {
      isEnrolled = enrolledUsers.any((user) => user.username == currentUser);
    });
  }

  Future<void> _toggleEnrollment() async {
    if (isEnrolled) {
      await _removeFromCase();
    } else {
      await _enrollUser();
    }
  }

  Future<void> _enrollUser() async {
    try {
      await APIService.enrollToCase(caseId);
      // Refresh enrolled users list after enrollment
      await _loadEnrolledUsers();
    } catch (e) {
      print('Failed to enroll user: $e');
      // Handle error as needed
    }
  }

  Future<void> _removeFromCase() async {
    try {
      await APIService.removeFromCase(caseId);
      // Refresh enrolled users list after removal
      await _loadEnrolledUsers();
    } catch (e) {
      print('Failed to remove user from case: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Basic Case Info
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              enrolledUsers.isEmpty
                  ? Center(child: Text('No enrolled users found'))
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
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Enroll/Unenroll Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _toggleEnrollment,
            child: Text(isEnrolled ? 'Verlassen' : 'Einschreiben'),
          ),
        ),
      ],
    );
  }
}