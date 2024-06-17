import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/middle_card.dart'; // Import für MiddleCard
import 'package:mobile_anw/models/case.dart';

import '../../../utils/text_theme_config.dart';

class SuggestionsSection extends StatefulWidget {
  final List<Case> cases;

  SuggestionsSection({required this.cases});

  @override
  _SuggestionsSectionState createState() => _SuggestionsSectionState();
}

class _SuggestionsSectionState extends State<SuggestionsSection> {
  @override
  Widget build(BuildContext context) {
    // Nehmen wir an, dass wir nur die nächsten vier Fälle für die Vorschläge verwenden
    final displayCases =
    widget.cases.length >= 8 ? widget.cases.sublist(4, 8) : widget.cases.skip(4).take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
      const Text('Vorschläge', style: MyTextStyles.smallHeading,),
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
