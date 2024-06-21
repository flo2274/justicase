import 'package:flutter/material.dart';
import 'package:mobile_anw/models/user.dart'; // Assuming User class is defined in user.dart

class UserItem extends StatelessWidget {
  final User user;
  final Function(int) onAddToCase;
  final Function(int) onRemoveFromCase;

  const UserItem({
    Key? key,
    required this.user,
    required this.onAddToCase,
    required this.onRemoveFromCase,
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
              '${user.username}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Email: ${user.email}'),
            SizedBox(height: 8.0),
            Text('Joined at: ${user.createdAt}'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Assuming caseId is hardcoded for demonstration
                    int caseId = 1; // Replace with dynamic caseId logic if applicable
                    onAddToCase(caseId);
                  },
                  child: Text('Add to Case'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Assuming caseId is hardcoded for demonstration
                    int caseId = 1; // Replace with dynamic caseId logic if applicable
                    onRemoveFromCase(caseId);
                  },
                  child: Text('Remove from Case'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
