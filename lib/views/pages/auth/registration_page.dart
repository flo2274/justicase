import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/services/api_service.dart';

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
      body: Column(
        children: [
          Container(
            color: Colors.grey,
            width: double.infinity,
            padding: EdgeInsets.all(35.0),
            child: Column(
              children: [
                Text(
                  'JUSTICE FOR YOUR CASE',
                  style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white54),
                ),
                SizedBox(height: 20.0),
                Text(
                  'WERDEN SIE TEIL UNSERER BEWEGUNG FÜR GERECHTIGKEIT',
                  style: TextStyle(fontSize: 12.0, color: Colors.white54),
                ),
              ],
            ),
          ),
          AppBar(
            title: Text('Willkommen bei Justicase'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Benutzername',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Dein Benutzername',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Email-Adresse',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Deine E-Mail-Adresse',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Passwort',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Dein Passwort',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
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
          ),
        ],
      ),
    );
  }
}
