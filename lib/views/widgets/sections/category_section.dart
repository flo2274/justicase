import 'package:flutter/material.dart';
import 'package:mobile_anw/utils/text_theme_config.dart';
import 'package:mobile_anw/views/widgets/cards/mini_card.dart';
import 'package:mobile_anw/data/case_data.dart';

class CategorySection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          const Text('Kategorien', style: MyTextStyles.smallHeading,
          ),
          const SizedBox(height: 5.0), // Abstand zwischen Überschrift und Karten
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: CaseData.industries.map((industry) => Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: MiniCard(name: industry),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
