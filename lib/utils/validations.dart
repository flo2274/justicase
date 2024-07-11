class Validations {
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isNotEmpty(String text) {
    return text.isNotEmpty;
  }

  static bool isValidUsername(String username) {
    return username.length >= 4;
  }
}
