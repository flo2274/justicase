import 'package:flutter/material.dart';
import 'package:mobile_anw/models/user.dart'; // Assuming User class is defined in user.dart

class AdminUserItem extends StatelessWidget {
  final User user;
  final Function(int) onDeleteUser;
  final Function(int) onGetCasesByUser;

  const AdminUserItem({
    Key? key,
    required this.user,
    required this.onDeleteUser,
    required this.onGetCasesByUser,
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
              '${user.firstName} ${user.lastName}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Username: ${user.username}'),
            SizedBox(height: 8.0),
            Text('Email: ${user.email}'),
            SizedBox(height: 8.0),
            Text('Joined at: ${user.createdAt}'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Assuming caseId is hardcoded for demonstration
                      int caseId = 1; // Replace with dynamic caseId logic if applicable
                      onDeleteUser(caseId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xCEFF3030),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Benutzer löschen'),
                  ),
                ),
                const SizedBox(width: 30), // Add space between buttons
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Assuming caseId is hardcoded for demonstration
                      int caseId = 1; // Replace with dynamic caseId logic if applicable
                      onGetCasesByUser(caseId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Fälle anzeigen'),
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
