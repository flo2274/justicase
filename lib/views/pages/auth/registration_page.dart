import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_anw/services/api_service.dart';
import 'package:mobile_anw/utils/helpers/image-animation_helper.dart';
import 'package:mobile_anw/utils/configs/text_theme_config.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _clearErrorMessage();
  }

  void _clearErrorMessage() {
    setState(() {
      _errorMessage = '';
    });
  }

  void _register() async {
    _clearErrorMessage();

    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String username = _usernameController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      final success = await APIService.register(
          firstName, lastName, username, email, password);
      if (success) {
        _performLogin(email, password);
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    String errorMessage = error.toString();
    if (errorMessage.contains('Registration failed')) {
      errorMessage = 'Nutzer bereits vorhanden.';
    } else if (errorMessage.contains('Invalid email')) {
      errorMessage = 'Ungültige Email.';
    } else if (errorMessage.contains('Invalid password')) {
      errorMessage = 'Ungültiges Passwort.';
    } else if (errorMessage.contains('Invalid username')) {
      errorMessage = 'Ungültiger Benutzername.';
    } else {
      errorMessage = 'Ein Fehler ist aufgetreten: $errorMessage';
    }

    // Show the error message in a banner
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );

    setState(() {
      _errorMessage = errorMessage;
    });
  }

  void _performLogin(String email, String password) async {
    _clearErrorMessage();

    try {
      final success = await APIService.login(email, password);
      if (success) {
        context.go('/home');
      } else {
        setState(() {
          _errorMessage =
          'Fehler beim automatischen Login nach der Registrierung.';
        });
      }
    } catch (e) {
      _handleError(e);
    }
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
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'JUSTICE FOR YOUR CASE',
                    style: TextThemeConfig.authLargeHeading,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'WIR SIND DIE BEWEGUNG FÜR GERECHTIGKEIT',
                    style: TextThemeConfig.authSmallHeading,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            ImageAnimationHelper(),
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                  'Willkommen,', style: TextThemeConfig.authWelcome1Text),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('schön dich wiederzusehen',
                  style: TextThemeConfig.authWelcome2Text),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        controller: _firstNameController,
                        labelText: 'Vorname',
                        maxLength: 30,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        controller: _lastNameController,
                        labelText: 'Nachname',
                        maxLength: 30,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        controller: _usernameController,
                        labelText: 'Benutzername',
                        maxLength: 20,
                        prefixIcon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        controller: _emailController,
                        labelText: 'E-Mail-Adresse',
                        maxLength: 50,
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextField(
                        controller: _passwordController,
                        labelText: 'Passwort',
                        maxLength: 20,
                        prefixIcon: Icons.lock_outlined,
                        obscureText: !_passwordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(_passwordVisible ? Icons.visibility : Icons
                              .visibility_off),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Registrieren',
                          style: TextThemeConfig.buttonText,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const Text(
                          'Schon ein Konto? Hier einloggen',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required int maxLength,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        counterText: '',
        counterStyle: TextStyle(fontSize: 0, height: 0), // Set size and height to 0 to hide
        border: OutlineInputBorder(),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
