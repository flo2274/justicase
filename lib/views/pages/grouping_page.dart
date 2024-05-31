import 'package:flutter/material.dart';

class GroupingPage extends StatefulWidget {
  const GroupingPage({Key? key}) : super(key: key);

  @override
  _GroupingPageState createState() => _GroupingPageState();
}

class _GroupingPageState extends State<GroupingPage> {
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
        body: const TabBarView(
          children: [
            TabForum(), // First tab content
            TabEnrolled(), // Second tab content
          ],
        ),
      ),
    );
  }
}

// Content for the first tab
class TabForum extends StatelessWidget {
  const TabForum({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.blue[50],
        child: const Text(
          'Content of Forum',
          style: TextStyle(
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
  const TabEnrolled({Key? key}) : super(key: key);

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
