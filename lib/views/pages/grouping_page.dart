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
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.green[50],
        child: const Text(
          'Content of Enrolled',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.green,
            fontFamily: 'PTSerif',
          ),
        ),
      ),
    );
  }
}
