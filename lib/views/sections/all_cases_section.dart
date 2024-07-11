import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/state/notifiers/case_notifier.dart';
import 'package:mobile_anw/utils/configs/text_theme_config.dart';
import '../items/big_case_item.dart';
import '../pages/case/case_details_page.dart';

class AllCasesSection extends ConsumerWidget {
  const AllCasesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseState = ref.watch(caseProvider);

    if (caseState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (caseState.errorMessage != null) {
      return Center(child: Text('Fehler beim Abrufen der Fälle: ${caseState.errorMessage}'));
    }

    if (caseState.allCases.isEmpty) {
      return const Center(child: Text('Keine Fälle gefunden.'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Text('Alle Fälle', style: TextThemeConfig.smallHeading),
          const SizedBox(height: 5.0),
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 1,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.5,
              ),
              itemCount: caseState.allCases.length,
              itemBuilder: (context, index) {
                final caseItem = caseState.allCases[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CaseDetailsPage(myCase: caseItem),
                      ),
                    );
                  },
                  child: BigCaseItem(caseItem: caseItem),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
