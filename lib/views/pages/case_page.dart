import 'package:flutter/material.dart';

class CasePage extends StatefulWidget {
  const CasePage({Key? key}) : super(key: key);

  @override
  _CasePageState createState() => _CasePageState();
}

class _CasePageState extends State<CasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('JUSTICASE')),
      ),
      body: const Center(
        child: Text(
          'Case',
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
