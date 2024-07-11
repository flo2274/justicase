import 'package:flutter/material.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/utils/configs/theme_config.dart';

class AdminUserItem extends StatelessWidget {
  final User user;
  final Function(int) onDeleteUser;
  final Function(int) onGetCasesByUser;
  final Function(int)? onRemoveUserFromCase;

  const AdminUserItem({
    super.key,
    required this.user,
    required this.onDeleteUser,
    required this.onGetCasesByUser,
    this.onRemoveUserFromCase,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onGetCasesByUser(user.id); // Invoke onGetCasesByUser callback
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.person,
                        size: 40.0,
                        color: Colors.blue,
                      ),
                      title: Text(
                        user.username,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8.0),
                          Text('Id: ${user.id}'),
                          const SizedBox(height: 8.0),
                          Text('Name: ${user.firstName} ${user.lastName}'),
                          const SizedBox(height: 8.0),
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
                      const SizedBox(height: 20.0), // Add space between icons
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
                      const SizedBox(height: 20.0), // Add space between icons
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
          title: const Text("Löschung bestätigen"),
          content: const Text("Möchten Sie diesen Benutzer wirklich löschen?"),
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
          title: const Text("Entfernen bestätigen"),
          content: const Text("Möchten Sie diesen Benutzer wirklich aus dem Fall entfernen?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Abbrechen"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
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
