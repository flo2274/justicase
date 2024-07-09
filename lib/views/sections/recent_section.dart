import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Import the go_router package
import 'package:mobile_anw/models/case.dart';

import '../../utils/configs/text_theme_config.dart';
import '../items/big-case_item.dart';

class RecentSection extends StatelessWidget {
  final List<Case> cases;

  RecentSection({required this.cases});

  @override
  Widget build(BuildContext context) {
    final displayCases = cases.length >= 4 ? cases.sublist(0, 4) : cases;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Text('Aktuelles', style: TextThemeConfig.smallHeading,),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: displayCases
                .take(2)
                .map((caseItem) => Expanded(
              child: GestureDetector(
                onTap: () {
                  context.go('/case/caseDetails', extra: caseItem);
                },
                child: BigCaseItem(caseItem: caseItem),
              ),
            ))
                .toList(),
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: displayCases
                .skip(2)
                .take(2)
                .map((caseItem) => Expanded(
              child: GestureDetector(
                onTap: () {
                  context.go('/case/caseDetails', extra: caseItem);
                },
                child: BigCaseItem(caseItem: caseItem),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
