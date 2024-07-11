import 'package:flutter/material.dart';
import 'package:mobile_anw/data/constants/case_data.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/helpers/emoji_helper.dart';
import '../../utils/configs/text_theme_config.dart';
import '../pages/case/case_details_page.dart';

class LongCaseItem extends StatelessWidget {
  final Case caseInfo;

  const LongCaseItem({super.key, required this.caseInfo});

  @override
  Widget build(BuildContext context) {
    double progress = caseInfo.userCount / CaseData.caseClosedUserCount;

    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CaseDetailsPage(myCase: caseInfo),
            ),
          );
        },
        child: Container(
          height: 110.0, // Feste Höhe für den CaseItem
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Industry Icon
              Container(
                alignment: Alignment.center,
                child: Icon(
                  EmojiHelper.getIndustryIcon(caseInfo.industry ?? ''),
                  size: 30,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Case Name
                    Text(
                      caseInfo.name ?? '',
                      style: TextThemeConfig.primaryLongCaseText
                    ),
                    const SizedBox(height: 4),
                    // Company Type
                    Text(
                      caseInfo.companyType ?? 'Kein Unternehmen',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextThemeConfig.secondaryLongCaseText,
                    ),
                    const SizedBox(height: 8),
                    // Progress Indicator and User Count
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Progress Indicator
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300]!,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              Container(
                                height: 8,
                                width: progress * 100.0,
                                decoration: BoxDecoration(
                                  color: progress >= 1.0 ? Colors.green : Colors.blue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // User Count
                        Text(
                          '${caseInfo.userCount} / ${CaseData.caseClosedUserCount}',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
