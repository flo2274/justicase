import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/helpers/emoji_helper.dart';
import 'package:go_router/go_router.dart';

class CaseItem extends StatelessWidget {
  final Case caseInfo;

  const CaseItem({Key? key, required this.caseInfo}) : super(key: key);

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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                EmojiHelper.getIndustryIcon(caseInfo.industry ?? ''),
                size: 30,
                color: Colors.blue,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caseInfo.name ?? '',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4),
                    Text(
                      caseInfo.companyType ?? 'Kein Unternehmen',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 10,
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300]!,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1.0 ? Colors.green : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
