import 'package:flutter/material.dart';
import 'package:mobile_anw/views/widgets/cards/middle_card.dart';
import 'package:mobile_anw/views/widgets/cards/small_card.dart';
import 'package:mobile_anw/views/widgets/texts/headings/large_heading.dart';


class CategorySection extends StatelessWidget {
  // Beispiel-Datensatz
  final List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
    'Category 4',
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
              SmallCard(name: categories[0]),
              SmallCard(name: categories[1]),
            ],
          ),
          const SizedBox(height: 16.0), // Abstand zwischen den Reihen
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SmallCard(name: categories[2]),
              SmallCard(name: categories[3]),
            ],
          ),
        ],
      ),
    );
  }
}
