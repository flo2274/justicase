import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/small_card.dart';
import 'package:mobile_anw/views/widgets/texts/headings/large_heading.dart';

// Todo@Mike : die case Elemente nach neuigkeit anzeigen (createdAt nutzen)

class SuggestionsSection extends StatelessWidget {
  final List<Map<String, dynamic>> cases;

  SuggestionsSection({required this.cases});

  @override
  Widget build(BuildContext context) {
    // Nehmen wir an, dass wir nur die nächsten vier Fälle für die Vorschläge verwenden
    final displayCases = cases.length >= 8 ? cases.sublist(4, 8) : cases.skip(4).take(4).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LargeHeading(
            text: 'Vorschläge',
          ),
          const SizedBox(height: 10.0), // Abstand zwischen Überschrift und Karten
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: displayCases
                .take(2)
                .map((caseItem) => SmallCard(name: caseItem['name']))
                .toList(),
          ),
          const SizedBox(height: 16.0), // Abstand zwischen den Reihen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: displayCases
                .skip(2)
                .take(2)
                .map((caseItem) => SmallCard(name: caseItem['name']))
                .toList(),
          ),
        ],
      ),
    );
  }
}
