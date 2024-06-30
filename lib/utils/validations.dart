import 'package:flutter/material.dart';

class Validations {
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    // Password must be at least 8 characters long
    // Add more rules as needed (e.g., at least one uppercase letter, one number, one special character)
    return password.length >= 6;
  }

  static bool isNotEmpty(String text) {
    return text.isNotEmpty;
  }

  static bool isValidUsername(String username) {
    // Add username validation rules as needed
    return username.length >= 4; // Example rule: minimum length of 4
  }
}
