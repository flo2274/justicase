import 'package:flutter/material.dart';
import 'package:mobile_anw/models/user.dart'; // Assuming User class is defined in user.dart

class AdminUserItem extends StatelessWidget {
  final User user;
  final Function(int) onDeleteUser;
  final Function(int) onGetCasesByUser;
  final Function(int)? onRemoveUserFromCase; // Optional parameter

  const AdminUserItem({
    Key? key,
    required this.user,
    required this.onDeleteUser,
    required this.onGetCasesByUser,
    this.onRemoveUserFromCase, // Optional parameter
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
            Text('Name: ${user.firstName} ${user.lastName}'),
            SizedBox(height: 8.0),
            Text('Email: ${user.email}'),
            SizedBox(height: 8.0),
            Text('Beigetreten: ${user.createdAt}'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onDeleteUser(user.id); // Pass user.id to the callback
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
                      onGetCasesByUser(user.id); // Pass user.id to the callback
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
                if (onRemoveUserFromCase != null) ...[
                  const SizedBox(width: 30), // Add space between buttons
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onRemoveUserFromCase!(user.id); // Pass user.id to the callback
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Aus Fall entfernen'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
