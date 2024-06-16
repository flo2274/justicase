import 'package:flutter/material.dart';

import '../../models/case.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';

class GroupingPage extends StatelessWidget {
  final Case caseInfo; // Use Case instead of Map<String, dynamic>

  const GroupingPage({Key? key, required this.caseInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('JUSTICASE')),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Forum'),
              Tab(text: 'Enrolled'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TabForum(caseInfo: caseInfo), // First tab content
            TabEnrolled(caseInfo: caseInfo), // Second tab content
          ],
        ),
      ),
    );
  }
}

// Content for the first tab
class TabForum extends StatelessWidget {
  final Case caseInfo;

  const TabForum({Key? key, required this.caseInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.blue[50],
        child: Text(
          'Content of Forum for case: ${caseInfo.name}',
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.blue,
            fontFamily: 'PTSerif',
          ),
        ),
      ),
    );
  }
}

// Content for the second tab
class TabEnrolled extends StatefulWidget {
  final Case caseInfo;

  const TabEnrolled({Key? key, required this.caseInfo}) : super(key: key);

  @override
  _TabEnrolledState createState() => _TabEnrolledState();
}

class _TabEnrolledState extends State<TabEnrolled> {
  List<User> enrolledUsers = [];
  late int caseId; // Variable zur Speicherung der Fall-ID

  @override
  void initState() {
    super.initState();
    // Initialisierung der Fall-ID
    caseId = widget.caseInfo.id!;
    _loadEnrolledUsers();
  }

  Future<void> _loadEnrolledUsers() async {
    try {
      // Verwendung von caseId, um die Benutzer für den Fall abzurufen
      List<User> users = await APIService.getUsersByCase(caseId);
      setState(() {
        enrolledUsers = users;
      });
    } catch (e) {
      print('Failed to load enrolled users: $e');
      // Fehlerbehandlung je nach Bedarf
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
              Text('ID: ${widget.caseInfo.id?? 'N/A'}'),
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
      ],
    );
  }
}

