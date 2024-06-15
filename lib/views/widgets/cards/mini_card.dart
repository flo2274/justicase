import 'package:flutter/material.dart';

class MiniCard extends StatelessWidget {
  final String name;

  MiniCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Höhe des Schattens
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Optionale Abrundung der Ecken
      ),
      child: Container(
        width: 120,
        height: 35,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16.0), // Padding für den Abstand vom linken Rand
        child: Text(
          name,
          style: const TextStyle(fontSize: 13.0),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
