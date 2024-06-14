import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/small_card.dart';
import 'package:mobile_anw/views/widgets/texts/headings/large_heading.dart';

class RecentSection extends StatelessWidget {
  final List<Map<String, dynamic>> cases;

  RecentSection({required this.cases});

  @override
  Widget build(BuildContext context) {
    // Nehmen wir an, dass wir die letzten vier Fälle für die kürzlich hinzugefügten Fälle verwenden
    final displayCases = cases.length >= 12 ? cases.sublist(8, 12) : cases.skip(8).take(4).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LargeHeading(
            text: 'Kürzlich hinzugefügt',
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
