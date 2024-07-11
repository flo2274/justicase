import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/helpers/emoji_helper.dart';

import '../../utils/configs/text_theme_config.dart';

class BigCaseItem extends StatelessWidget {
  final Case caseItem;

  BigCaseItem({required this.caseItem});

  String truncateText(String text, TextStyle style, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);

    if (textPainter.width > maxWidth) {
      for (int endIndex = text.length - 1; endIndex >= 0; endIndex--) {
        final truncatedText = text.substring(0, endIndex) + '...';
        textPainter.text = TextSpan(text: truncatedText, style: style);
        textPainter.layout(minWidth: 0, maxWidth: double.infinity);

        if (textPainter.width <= maxWidth) {
          return truncatedText;
        }
      }

      return '...';
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData = EmojiHelper.getIndustryIcon(caseItem.industry!);

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
              truncateText(
                caseItem.name!,
                const TextStyle(fontSize: 22.0),
                MediaQuery.of(context).size.width / 2.5 - 32.0,
              ),
              style: TextThemeConfig.primaryBigCaseText,
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
