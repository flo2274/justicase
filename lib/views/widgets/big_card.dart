import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  final String name;

  BigCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 150,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16.0), // Padding für den Abstand vom linken Rand
        child: Text(
          name,
          style: const TextStyle(fontSize: 18.0),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}