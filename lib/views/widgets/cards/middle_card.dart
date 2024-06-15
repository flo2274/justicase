import 'package:flutter/material.dart';

class MiddleCard extends StatelessWidget {
  final String name;

  MiddleCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0, // Höhe des Schattens
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0), // Optionale Abrundung der Ecken
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        height: 150,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 16.0), // Padding für den Abstand vom linken Rand
        child: Text(
          name,
          style: const TextStyle(fontSize: 22.0),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}