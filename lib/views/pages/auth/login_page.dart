import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/services/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final success = await APIService.login(email, password);
      if (success) {
        // Navigate to another page upon successful login
        if (mounted) {
          context.go('/home');
        }
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
          //hier widget imageswitcher
          Container(
            child: Text('Willkommen bei Justicase'),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/registration');
                    },
                    child: const Text('Register'),
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
