// lib/services/api_config.dart

class ApiConfig {
  static const String baseUrl = 'http://localhost:3000';
  static const String registerURL = '$baseUrl/auth/register';
  static const String loginURL = '$baseUrl/auth/login';
  static const String usersURL = '$baseUrl/users';
  static const String casesURL = '$baseUrl/cases';
  static const String casesByUsersURL = '$casesURL/user';
  static const String usersByCaseURL = '$usersURL/case';
}
