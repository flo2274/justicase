import 'package:flutter/material.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: const Center(
        child: Text(
          'Forum',
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.grey,
            fontFamily: 'PTSerif',
          ),
        ),
      ),
    );
  }
}
