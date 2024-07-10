import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../state/notifiers/case_notifier.dart';
import '../../../utils/configs/text_theme_config.dart';

class CaseDetailsEnrolled extends ConsumerStatefulWidget {
  final Case myCase;

  const CaseDetailsEnrolled({Key? key, required this.myCase}) : super(key: key);

  @override
  _CaseDetailsEnrolledState createState() => _CaseDetailsEnrolledState();
}

class _CaseDetailsEnrolledState extends ConsumerState<CaseDetailsEnrolled> {
  List<User> enrolledUsers = [];
  late int caseId;
  bool isEnrolled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    caseId = widget.myCase.id!;
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
      _isLoading = true;
    });

    try {
      if (isEnrolled) {
        await _removeFromCase();
      } else {
        await _enrollUser();
      }
      ref.read(caseProvider.notifier).fetchUserCases();
    } catch (e) {
      print('Failed to toggle enrollment: $e');
      // Handle error as needed
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _enrollUser() async {
    try {
      await APIService.addUserToCase(caseId);
      await _fetchEnrolledUsers();
    } catch (e) {
      print('Failed to enroll user: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFromCase() async {
    try {
      await APIService.removeUserFromCase(caseId);
      await _fetchEnrolledUsers();
    } catch (e) {
      print('Failed to remove user from case: $e');
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
                  // Enrolled Users List
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Eingetragene User', style: TextThemeConfig.smallHeading,),
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