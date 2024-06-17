import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/utils/image_switcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey,
              width: double.infinity,
              padding: EdgeInsets.all(35.0),
              child: const Column(
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
            SizedBox(height: 60.0),
            ImageSwitcher(),
            SizedBox(height: 60.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Willkommen bei Justicase', style: Theme.of(context).textTheme.headlineLarge),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Email-Adresse',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Deine E-Mail-Adresse',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Passwort',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Dein Passwort',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Runde Ecken
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextButton(
                        onPressed: () {
                          context.go('/registration');
                        },
                        child: const Text(
                          'Noch kein Konto? Hier registrieren',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
