import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/emoji_helper.dart';

class MiddleCard extends StatelessWidget {
  final Case caseItem;

  MiddleCard({required this.caseItem});

  @override
  Widget build(BuildContext context) {
    IconData iconData = EmojiHelper.getIndustryIcon(caseItem.industry!); // Verwende EmojiHelper für das Icon

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        height: 150,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              caseItem.name!,
              style: const TextStyle(fontSize: 22.0),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8.0),
            Text(
              '${caseItem.companyType}',
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 8.0),
            Icon(
              iconData,
              size: 32.0,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
