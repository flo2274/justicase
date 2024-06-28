import 'package:flutter/material.dart';
import 'package:mobile_anw/models/user.dart'; // Assuming User class is defined in user.dart
import 'package:mobile_anw/utils/theme_config.dart';

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
    return GestureDetector(
      onTap: () {
        onGetCasesByUser(user.id); // Invoke onGetCasesByUser callback
      },
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
                        Icons.person,
                        size: 40.0,
                        color: Colors.blue,
                      ),
                      title: Text(
                        '${user.username}',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8.0),
                          Text('Id: ${user.id}'),
                          SizedBox(height: 8.0),
                          Text('Name: ${user.firstName} ${user.lastName}'),
                          SizedBox(height: 8.0),
                          Text('Email: ${user.email}'),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showDeleteConfirmationDialog(context, user.id);
                        },
                        child: Icon(
                          Icons.delete_outline_rounded,
                          color: ThemeConfig.darkGreyAccent,
                          size: 30.0,
                        ),
                      ),
                      SizedBox(height: 20.0), // Add space between icons
                      GestureDetector(
                        onTap: () {
                          onGetCasesByUser(user.id);
                        },
                        child: Icon(
                          Icons.chevron_right,
                          color: ThemeConfig.darkGreyAccent,
                          size: 25.0,
                        ),
                      ),
                      SizedBox(height: 20.0), // Add space between icons
                      if (onRemoveUserFromCase != null) // Conditionally show the button
                        GestureDetector(
                          onTap: () {
                            _showRemoveUserFromCaseConfirmationDialog(context, user.id);
                          },
                          child: Icon(
                            Icons.person_remove_outlined,
                            color: ThemeConfig.darkGreyAccent,
                            size: 30.0,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Löschung bestätigen"),
          content: Text("Möchten Sie diesen Benutzer wirklich löschen?"),
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
                onDeleteUser(userId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showRemoveUserFromCaseConfirmationDialog(BuildContext context, int userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Entfernen bestätigen"),
          content: Text("Möchten Sie diesen Benutzer wirklich aus dem Fall entfernen?"),
          actions: <Widget>[
            TextButton(
              child: Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Entfernen",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                if (onRemoveUserFromCase != null) {
                  onRemoveUserFromCase!(userId);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
