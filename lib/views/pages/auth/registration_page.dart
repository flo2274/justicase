import 'package:flutter/material.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:go_router/go_router.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register() async {
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final success = await APIService.register(username, email, password);
      if (success) {
        // After successful registration, automatically login
        await _login(email, password);
        if (mounted) {
          context.go('/home');
        }
      } else {
        // Handle registration failure
      }
    } catch (e) {
      // Handle registration failure
      print('Registration failed: $e');
    }
  }

  Future<void> _login(String email, String password) async {
    try {
      final success = await APIService.login(email, password);
      if (success) {
        // Login successful
      } else {
        // Handle login failure
      }
    } catch (e) {
      // Handle login failure
      print('Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}



/*class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Benutzername'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Passwort'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-Mail'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _registerUser,
              child: const Text('Registrieren'),
            ),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    if (username.isNotEmpty && password.isNotEmpty && email.isNotEmpty) {
      try {
        await ApiService.createUser(username, password, email);
        print('Benutzer wurde erfolgreich erstellt.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Benutzer wurde erfolgreich erstellt.'),
        ));
        context.go('/home');
      } catch (e) {
        print('Fehler beim Erstellen des Benutzers: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Fehler beim Erstellen des Users: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Bitte geben Sie Benutzername, Passwort und E-Mail ein.'),
      ));
    }
  }
}
*/
