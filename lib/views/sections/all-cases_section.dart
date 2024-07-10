import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/helpers/emoji_helper.dart';
import 'package:mobile_anw/state/notifiers/case_notifier.dart';
import 'package:mobile_anw/state/models/case_state.dart';
import 'package:mobile_anw/utils/configs/text_theme_config.dart';
import '../items/big-case_item.dart';
import 'package:go_router/go_router.dart';

class AllCasesSection extends ConsumerWidget {
  const AllCasesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseState = ref.watch(caseProvider);

    if (caseState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (caseState.errorMessage != null) {
      return Center(child: Text('Fehler beim Abrufen der Fälle: ${caseState.errorMessage}'));
    }

    if (caseState.allCases.isEmpty) {
      return Center(child: Text('Keine Fälle gefunden.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text('Alle Fälle', style: TextThemeConfig.smallHeading),
        const SizedBox(height: 5.0),
        LimitedBox(
          maxHeight: MediaQuery.of(context).size.height * 1,
          child: GridView.builder(
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
                  context.go('/case/caseDetails', extra: caseItem);
                },
                child: BigCaseItem(caseItem: caseItem),
              );
            },
          ),
        ),
      ],
    );
  }
}
