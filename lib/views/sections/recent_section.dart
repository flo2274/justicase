import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import '../../utils/configs/text_theme_config.dart';
import '../items/big-case_item.dart';
import '../pages/case/case-details_page.dart';

class RecentSection extends StatelessWidget {
  final List<Case> cases;

  const RecentSection({super.key, required this.cases});

  @override
  Widget build(BuildContext context) {
    cases.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    final displayCases = cases.length >= 4 ? cases.sublist(0, 4) : cases;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Text('Aktuelles', style: TextThemeConfig.smallHeading),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: displayCases
                .take(2)
                .map((caseItem) => Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CaseDetailsPage(myCase: caseItem),
                    ),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CaseDetailsPage(myCase: caseItem),
                    ),
                  );
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
