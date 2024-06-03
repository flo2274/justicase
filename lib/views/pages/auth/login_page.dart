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
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
              onPressed: _login,
              child: Text('Login'),
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
    );
  }
}


/*
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Justicase',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30.0),
            _buildForm(context),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 20.0),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Todo: login logic
              //goRouter.go('/home');
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: () {
              // Todo: logic for password forgotten
            },
            child: const Text('Forgot Password?'),
          ),
          TextButton(
            onPressed: () {
              context.go('/registration');
            },
            child: const Text('Register'),
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  // Navigate to registration page
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/

