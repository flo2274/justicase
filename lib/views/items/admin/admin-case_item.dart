import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/helpers/emoji_helper.dart';
import 'package:mobile_anw/utils/configs/theme_config.dart';

import '../../../data/constants/case_data.dart';

class AdminCaseItem extends StatelessWidget {
  final Case caseItem;
  final Function onDelete;
  final Function onGetUsersByCase;

  const AdminCaseItem({
    super.key,
    required this.caseItem,
    required this.onDelete,
    required this.onGetUsersByCase,
  });

  @override
  Widget build(BuildContext context) {
    double progress = caseItem.userCount / CaseData.caseClosedUserCount;

    bool isProgressBarFull = progress >= 1.0;

    return GestureDetector(
      onTap: () => onGetUsersByCase(caseItem),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        EmojiHelper.getIndustryIcon(caseItem.industry ?? ''),
                        size: 40.0,
                        color: Colors.blue,
                      ),
                      title: Text(
                        '${caseItem.name}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          Text('ID: ${caseItem.id}'),
                          const SizedBox(height: 8.0),
                          Text('Unternehmensform: ${caseItem.companyType}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        minHeight: 10,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isProgressBarFull ? Colors.green : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _showDeleteConfirmationDialog(context),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: ThemeConfig.darkGreyAccent,
                        size: 30.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  GestureDetector(
                    onTap: () => onGetUsersByCase(caseItem),
                    child: Icon(
                      Icons.chevron_right,
                      color: ThemeConfig.darkGreyAccent,
                      size: 25.0,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Icon(
                    Icons.outgoing_mail,
                    color: isProgressBarFull ? Colors.green : Colors.grey[400],
                    size: 30.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Löschen bestätigen"),
          content: const Text("Möchten Sie diesen Fall wirklich löschen?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Löschen",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
