import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/helpers/emoji_helper.dart';
import 'package:go_router/go_router.dart';

import '../../utils/configs/text_theme_config.dart';

class LongCaseItem extends StatelessWidget {
  final Case caseInfo;

  const LongCaseItem({Key? key, required this.caseInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = caseInfo.userCount != null
        ? caseInfo.userCount / 50.0 // Todo: make 50 constant global variable
        : 0.0;

    return Card(
      child: InkWell(
        onTap: () {
          context.go('/case/caseDetails', extra: caseInfo);
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
              SizedBox(width: 12),
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
                    SizedBox(height: 4),
                    // Company Type
                    Text(
                      caseInfo.companyType ?? 'Kein Unternehmen',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextThemeConfig.secondaryLongCaseText,
                    ),
                    SizedBox(height: 8),
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
                        SizedBox(width: 8),
                        // User Count
                        Text(
                          '${caseInfo.userCount ?? 0} / 50',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
