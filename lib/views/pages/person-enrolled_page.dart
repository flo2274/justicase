import 'package:flutter/material.dart';

class PersonEnrolledPage extends StatefulWidget {
  const PersonEnrolledPage({Key? key}) : super(key: key);

  @override
  _PersonEnrolledPageState createState() => _PersonEnrolledPageState();
}

class _PersonEnrolledPageState extends State<PersonEnrolledPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: const Center(
        child: Text(
          'Home',
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
