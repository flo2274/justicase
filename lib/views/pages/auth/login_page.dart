import 'package:flutter/material.dart';
import 'package:mobile_anw/views/pages/background/screen_background.dart';

import 'package:flutter/material.dart';

class Login extends StatelessWidget {
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
              // Do login logic here
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ScreenBackground()),
              );
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 10.0),
          TextButton(
            onPressed: () {
              // Do forgot password logic here
            },
            child: const Text('Forgot Password?'),
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
}

