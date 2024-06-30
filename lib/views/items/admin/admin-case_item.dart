import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/helpers/emoji_helper.dart';
import 'package:mobile_anw/utils/configs/theme_config.dart';

class AdminCaseItem extends StatelessWidget {
  final Case caseItem;
  final Function onDelete;
  final Function onGetUsersByCase;

  const AdminCaseItem({
    Key? key,
    required this.caseItem,
    required this.onDelete,
    required this.onGetUsersByCase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = caseItem.userCount != null
        ? caseItem.userCount / 50.0 // Todo: make 50 a constant global variable
        : 0.0;

    return GestureDetector(
      onTap: () => onGetUsersByCase(caseItem),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        EmojiHelper.getIndustryIcon(caseItem.industry ?? ''),
                        size: 40.0,
                        color: Colors.blue,
                      ),
                      title: Text(
                        '${caseItem.name}',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Text('ID: ${caseItem.id}'),
                          SizedBox(height: 8.0),
                          Text('Unternehmensform: ${caseItem.companyType}'),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    // Ensure icons are top-aligned
                    children: [
                      GestureDetector(
                        onTap: () => _showDeleteConfirmationDialog(context),
                        child: Padding(
                          padding: EdgeInsets.only(top: 0.0),
                          // Adjust top padding
                          child: Icon(
                            Icons.delete_outline_rounded,
                            color: ThemeConfig.darkGreyAccent,
                            size: 30.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 15.0), // Add space between icons
                      GestureDetector(
                        onTap: () => onGetUsersByCase(caseItem),
                        child: Icon(
                          Icons.chevron_right,
                          color: ThemeConfig.darkGreyAccent,
                          size: 25.0,
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                // Horizontal padding
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  minHeight: 10,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1.0 ? Colors.green : Colors.blue,
                  ),
                ),
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
          title: Text("Löschen bestätigen"),
          content: Text("Möchten Sie diesen Fall wirklich löschen?"),
          actions: <Widget>[
            TextButton(
              child: Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
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
