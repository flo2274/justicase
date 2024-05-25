import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/middle_card.dart';
import 'package:mobile_anw/views/widgets/cards/small_card.dart';
import 'package:mobile_anw/views/widgets/headings/primary_heading.dart';

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
          const PrimaryHeading(
            text: 'Vorschläge',
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
