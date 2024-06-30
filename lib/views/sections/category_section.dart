import 'package:flutter/material.dart';
import 'package:mobile_anw/utils/configs/text_theme_config.dart';
import 'package:mobile_anw/data/constants/case_data.dart';
import 'package:go_router/go_router.dart';

import '../items/category-case_item.dart'; // Import der go_router Bibliothek für die Navigation

class CategorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Text(
            'Kategorien',
            style: TextThemeConfig.smallHeading,
          ),
          const SizedBox(height: 5.0), // Abstand zwischen Überschrift und Karten
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: CaseData.industries.map((industry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: GestureDetector(
                    onTap: () {
                      context.go('/home/industry', extra: industry);
                    },
                    child: CategoryCaseItem(name: industry),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
