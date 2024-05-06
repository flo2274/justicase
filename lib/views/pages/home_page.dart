import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
