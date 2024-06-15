import 'package:flutter/material.dart';

class GroupingPage extends StatelessWidget {
  final Map<String, dynamic> caseInfo;

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
  final Map<String, dynamic> caseInfo;

  const TabForum({Key? key, required this.caseInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.blue[50],
        child: Text(
          'Content of Forum for case: ${caseInfo['name']}',
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
class TabEnrolled extends StatelessWidget {
  final Map<String, dynamic> caseInfo;

  const TabEnrolled({Key? key, required this.caseInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> contacts = [
      {'name': 'John Doe', 'phone': '123-456-7890'},
      {'name': 'Jane Smith', 'phone': '987-654-3210'},
      {'name': 'Sam Johnson', 'phone': '555-555-5555'},
      {'name': 'Lucy Brown', 'phone': '444-444-4444'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text(contacts[index]['name']!),
            subtitle: Text(contacts[index]['phone']!),
          ),
        );
      },
    );
  }
}
