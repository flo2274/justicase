import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';

import '../../utils/configs/text_theme_config.dart';
import '../items/big-case_item.dart';
import '../pages/case/case-details_page.dart';

class SuggestionsSection extends StatefulWidget {
  final List<Case> cases;

  const SuggestionsSection({super.key, required this.cases});

  @override
  _SuggestionsSectionState createState() => _SuggestionsSectionState();
}

class _SuggestionsSectionState extends State<SuggestionsSection> {
  late Future<List<Case>> _suggestedCases;

  @override
  void initState() {
    super.initState();
    _suggestedCases = APIService.getCasesWithMostEnrolledUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Text('Trends', style: TextThemeConfig.smallHeading),
          const SizedBox(height: 5.0),
          FutureBuilder<List<Case>>(
            future: _suggestedCases,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('Keine Vorschläge verfügbar.');
              }

              final displayCases = snapshot.data!;

              return Column(
                children: [
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
              );
            },
          ),
        ],
      ),
    );
  }
}
