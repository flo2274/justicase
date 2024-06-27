import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/case_notifier.dart';
import '../../../utils/text_theme_config.dart';

class CaseDetailsEnrolled extends ConsumerStatefulWidget {
  final Case caseInfo;

  const CaseDetailsEnrolled({Key? key, required this.caseInfo}) : super(key: key);

  @override
  _CaseDetailsEnrolledState createState() => _CaseDetailsEnrolledState();
}

class _CaseDetailsEnrolledState extends ConsumerState<CaseDetailsEnrolled> {
  List<User> enrolledUsers = [];
  late int caseId; // Variable to store the case ID
  bool isEnrolled = false; // Variable to track if current user is enrolled
  bool _isLoading = false; // Loading state for API operations

  @override
  void initState() {
    super.initState();
    caseId = widget.caseInfo.id!;
    _fetchEnrolledUsers();
    ref.read(caseProvider.notifier).fetchAllCases();
  }

  Future<void> _fetchEnrolledUsers() async {
    try {
      setState(() {
        _isLoading = true;
      });
      List<User> users = await APIService.getUsersByCase(caseId);
      setState(() {
        enrolledUsers = users;
        _isLoading = false;
      });
      await _checkEnrollmentStatus();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
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


  void _toggleEnrollment() async {
    setState(() {
      _isLoading = true; // Assuming _isLoading is defined in your state
    });

    try {
      if (isEnrolled) {
        await _removeFromCase();
      } else {
        await _enrollUser();
      }
      // After toggle enrollment, trigger fetchUserCases using caseProvider
      ref.read(caseProvider.notifier).fetchUserCases();
    } catch (e) {
      print('Failed to toggle enrollment: $e');
      // Handle error as needed
    } finally {
      setState(() {
        _isLoading = false; // Assuming _isLoading is defined in your state
      });
    }
  }


  Future<void> _enrollUser() async {
    try {
      await APIService.addUserToCase(caseId);
      // Refresh enrolled users list after enrollment
      await _fetchEnrolledUsers();
    } catch (e) {
      print('Failed to enroll user: $e');
      // Handle error as needed
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromCase() async {
    try {
      await APIService.removeUserFromCase(caseId);
      // Refresh enrolled users list after removal
      await _fetchEnrolledUsers();
    } catch (e) {
      print('Failed to remove user from case: $e');
      // Handle error as needed
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Neuen Fall erstellen', style: MyTextStyles.largeHeading,),
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
                        Text('Eingetragene User', style: MyTextStyles.smallHeading,),
                        SizedBox(height: 8),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : enrolledUsers.isEmpty
                            ? const Center(child: Text('Kein User ist eingetragen'))
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
                ],
              ),
            ),
          ),

          // Enroll/Unenroll Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _toggleEnrollment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(isEnrolled ? 'Verlassen' : 'Einschreiben'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}