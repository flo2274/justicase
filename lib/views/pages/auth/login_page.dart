import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/utils/helpers/image-animation_helper.dart';
import 'package:mobile_anw/utils/configs/text_theme_config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
        context.go('/home');
      } else {
        _showErrorBanner('Fehler beim Einloggen. Überprüfen Sie Ihre Eingaben.');
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
        if (errorMessage == 'Invalid email') {
          errorMessage = 'Ungültige E-Mail.';
        }
      }
      _showErrorBanner('Ein Fehler ist aufgetreten: $errorMessage');
    }
  }

  void _showErrorBanner(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'JUSTICE FOR YOUR CASE',
                    style: TextThemeConfig.authLargeHeading,
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'WIR SIND DIE BEWEGUNG FÜR GERECHTIGKEIT',
                    style: TextThemeConfig.authSmallHeading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const ImageAnimationHelper(),
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Willkommen,', style: TextThemeConfig.authWelcome1Text),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('schön dich wiederzusehen', style: TextThemeConfig.authWelcome2Text),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _emailController,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          labelText: 'Deine E-Mail-Adresse',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                          counterText: '',
                          counterStyle: TextStyle(fontSize: 0, height: 0), // Hide counter text
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextField(
                        controller: _passwordController,
                        maxLength: 20,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Dein Passwort',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          counterText: '',
                          counterStyle: const TextStyle(fontSize: 0, height: 0),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextThemeConfig.buttonText,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextButton(
                        onPressed: () {
                          context.go('/registration');
                        },
                        child: const Text(
                          'Noch kein Konto? Hier registrieren',
                          style: TextStyle(fontSize: 12.0, color: Colors.blue),
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
