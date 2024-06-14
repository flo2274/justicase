import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/small_card.dart';
import 'package:mobile_anw/views/widgets/texts/headings/large_heading.dart';

class CategorySection extends StatelessWidget {

  //Todo make global
  final List<String> _industries = [
    'Technologie',
    'Gesundheit',
    'Bildung',
    'Finanzen',
    'Einzelhandel',
    'Online',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LargeHeading(
            text: 'Kategorien',
          ),
          const SizedBox(height: 10.0), // Abstand zwischen Überschrift und Karten
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: SmallCard(name: _industries[0]),
              ),
              Expanded(
                child: SmallCard(name: _industries[1]),
              ),
              Expanded(
                child: SmallCard(name: _industries[2]),
              ),
            ],
          ),
          const SizedBox(height: 10.0), // Abstand zwischen den Reihen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: SmallCard(name: _industries[3]),
              ),
              Expanded(
                child: SmallCard(name: _industries[4]),
              ),
              Expanded(
                child: SmallCard(name: _industries[5]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
