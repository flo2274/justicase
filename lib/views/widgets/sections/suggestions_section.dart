import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/middle_card.dart'; // Import für MiddleCard
import 'package:mobile_anw/views/widgets/texts/headings/small_heading.dart';

class SuggestionsSection extends StatefulWidget {
  final List<Map<String, dynamic>> cases;

  SuggestionsSection({required this.cases});

  @override
  _SuggestionsSectionState createState() => _SuggestionsSectionState();
}

class _SuggestionsSectionState extends State<SuggestionsSection> {


  @override
  Widget build(BuildContext context) {
    // Nehmen wir an, dass wir nur die nächsten vier Fälle für die Vorschläge verwenden
    final displayCases = widget.cases.length >= 8 ? widget.cases.sublist(4, 8) : widget.cases.skip(4).take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          const SmallHeading(
            text: 'Vorschläge',
          ),
          const SizedBox(height: 5.0), // Abstand zwischen Überschrift und Karten
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: displayCases
                .take(2) // Zwei Karten in einer Reihe
                .map((caseItem) => Expanded(
              child: MiddleCard(name: caseItem['name']),
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
              child: MiddleCard(name: caseItem['name']),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
