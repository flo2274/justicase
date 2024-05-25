import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/middle_card.dart';
import 'package:mobile_anw/views/widgets/small_card.dart';

class SuggestionsSection extends StatelessWidget {
  // Beispiel-Datensatz
  final List<String> suggestions = [
    'Suggestion 1',
    'Suggestion 2',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vorschläge',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0), // Abstand zwischen Überschrift und Karten
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MiddleCard(name: suggestions[0]),
              MiddleCard(name: suggestions[1]),
            ],
          ),
        ],
      ),
    );
  }
}
