import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/middle_card.dart';
import 'package:mobile_anw/models/case.dart';

import '../../../utils/text_theme_config.dart';

class RecentSection extends StatelessWidget {
  final List<Case> cases;

  RecentSection({required this.cases});

  @override
  Widget build(BuildContext context) {
    // Nehmen wir an, dass wir die letzten vier Fälle für die kürzlich hinzugefügten Fälle verwenden
    final displayCases = cases.length >= 4 ? cases.sublist(0, 4) : cases;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          const Text('Aktuelles', style: MyTextStyles.smallHeading,),
          const SizedBox(height: 5.0), // Abstand zwischen Überschrift und Karten
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: displayCases
                .take(2) // Zwei Karten in einer Reihe
                .map((caseItem) => Expanded(
              child: MiddleCard(caseItem: caseItem),
            ))
                .toList(),
          ),
          const SizedBox(height: 5.0), // Abstand zwischen den Reihen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: displayCases
                .skip(2)
                .take(2) // Zwei Karten in einer Reihe
                .map((caseItem) => Expanded(
              child: MiddleCard(caseItem: caseItem),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
