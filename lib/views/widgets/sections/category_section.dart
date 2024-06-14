import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/middle_card.dart';
import 'package:mobile_anw/views/widgets/cards/small_card.dart';
import 'package:mobile_anw/views/widgets/texts/headings/large_heading.dart';

// Todo@Mike : zu den kategorien icons auf der rechten seite hinzufügen

class CategorySection extends StatelessWidget {

  final List<String> _industries = [
    'Technologie',
    'Gesundheitswesen',
    'Bildung',
    'Finanzen',
    'Einzelhandel',
    'Online',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
              SmallCard(name: _industries[0]),
              SmallCard(name: _industries[1]),
            ],
          ),
          const SizedBox(height: 16.0), // Abstand zwischen den Reihen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SmallCard(name: _industries[2]),
              SmallCard(name: _industries[3]),
            ],
          ),
          const SizedBox(height: 16.0), // Abstand zwischen den Reihen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SmallCard(name: _industries[4]),
              SmallCard(name: _industries[5]),
            ],
          ),
        ],
      ),
    );
  }
}
