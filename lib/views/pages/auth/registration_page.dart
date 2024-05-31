import 'package:flutter/material.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/models/user.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrieren'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'E-Mail'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Registrieren'),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    final name = _nameController.text;
    final email = _emailController.text;

    if (name.isNotEmpty && email.isNotEmpty) {
      final newUser = User(
        id: 0,
        name: name,
        email: email,
      );

      try {
        await ApiService.createUser(newUser);
        print('Benutzer wurde erfolgreich erstellt.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Benutzer wurde erfolgreich erstellt.'),
        ));
        Navigator.pop(context);
      } catch (e) {
        print('Fehler beim Erstellen des Benutzers: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fehler beim Erstellen des Users: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Bitte geben Sie Name und E-Mail ein.'),
      ));
    }
  }
}
