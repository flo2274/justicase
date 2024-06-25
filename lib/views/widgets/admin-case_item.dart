import 'package:flutter/material.dart';
import 'package:mobile_anw/models/case.dart';

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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case ID: ${caseItem.id}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Name: ${caseItem.name}'),
            SizedBox(height: 8.0),
            Text('Type: ${caseItem.companyType}'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onDelete(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
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
                    onPressed: () => onGetUsersByCase(caseItem.id),
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
