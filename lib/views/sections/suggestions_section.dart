import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/services/api_service.dart';

import '../../utils/configs/text_theme_config.dart';
import '../items/big-case_item.dart';

class SuggestionsSection extends StatefulWidget {
  final List<Case> cases;

  SuggestionsSection({Key? key, required this.cases}) : super(key: key);

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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Text('Beliebteste', style: TextThemeConfig.smallHeading),
          const SizedBox(height: 5.0),
          FutureBuilder<List<Case>>(
            future: _suggestedCases,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('Keine Vorschläge verfügbar.');
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
              );
            },
          ),
        ],
      ),
    );
  }
}
