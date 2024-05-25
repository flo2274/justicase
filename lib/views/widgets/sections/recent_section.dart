import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/middle_card.dart';
import 'package:mobile_anw/views/widgets/cards/small_card.dart';
import 'package:mobile_anw/views/widgets/headings/primary_heading.dart';

class RecentSection extends StatelessWidget {
  // Beispiel-Datensatz
  final List<String> recents = [
    'Neu 1',
    'Neu 2',
    'Neu 3',
    'Neu 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PrimaryHeading(
            text: 'Aktuell',
          ),
          const SizedBox(height: 10.0), // Abstand zwischen Überschrift und Karten
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MiddleCard(name: recents[0]),
              MiddleCard(name: recents[1]),
            ],
          ),
          const SizedBox(height: 16.0), // Abstand zwischen den Reihen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MiddleCard(name: recents[2]),
              MiddleCard(name: recents[3]),
            ],
          ),
        ],
      ),
    );
  }
}
