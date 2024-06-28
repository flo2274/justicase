import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/utils/emoji_helper.dart';

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
        ? caseItem.userCount! / 50.0 // Todo: make 50 a constant global variable
        : 0.0;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                EmojiHelper.getIndustryIcon(caseItem.industry ?? ''),
                size: 40.0,
              ),
              title: Text(
                '${caseItem.name}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text('ID: ${caseItem.id}'),
                  SizedBox(height: 8.0),
                  Text('Unternehmensform: ${caseItem.companyType}'),
                  SizedBox(height: 16.0),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    minHeight: 10,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress >= 1.0 ? Colors.green : Colors.blue,
                    ), // Adjust colors as needed
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onDelete(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xCEFF3030),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Fall löschen'),
                  ),
                ),
                const SizedBox(width: 30), // Add space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onGetUsersByCase(caseItem),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Benutzer anzeigen'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
