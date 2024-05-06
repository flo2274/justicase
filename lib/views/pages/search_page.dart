import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: const Center(
        child: Text(
          'Search',
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
