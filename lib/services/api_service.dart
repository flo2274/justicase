import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/models/case.dart';

class APIService {
  static const String baseURL = 'http://localhost:3000';
  static const String registerURL = '$baseURL/register';
  static const String loginURL = '$baseURL/login';
  static const String usersURL = '$baseURL/users';
  static const String casesURL = '$baseURL/cases';
  static const String myCasesURL = '$baseURL/getmycases';
  static const String usersByCaseURL = '$baseURL/getusersbycase';
  static const String addUserToCaseURL = '$baseURL/addusertocase';
  static const String removeUserFromCaseURL = '$baseURL/removeuserfromcase';

  static final storage = FlutterSecureStorage();

  static Future<bool> register(String firstName, String lastName, String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(registerURL),
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'username': username,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 400) {
        // Handle validation errors
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        String errorMessage = 'Registration failed';
        if (errorResponse.containsKey('errors')) {
          errorMessage = errorResponse['errors'].join('\n');
        }
        print('Registration failed: $errorMessage');
        throw Exception(errorMessage);
      } else {
        print('Failed to register: ${response.statusCode}');
        throw Exception('Failed to register: ${response.statusCode}');
      }
    } catch (e) {
      print('Registration failed: $e');
      throw Exception('Failed to register: $e');
    }
  }

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginURL),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Ensure the data contains the expected structure
      if (data != null && data.containsKey('token') && data['user'] != null && data['user'].containsKey('username') && data['user'].containsKey('role')) {
        final String token = data['token'];
        final String username = data['user']['username'];
        final String role = data['user']['role'];

        await storage.write(key: 'token', value: token);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('role', role);

        return true;
      } else {
        print('Unexpected JSON structure: $data');
        return false;
      }
    } else {
      print('Failed to login: ${response.body}');
      return false;
    }
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await storage.delete(key: 'token');
    await prefs.remove('username');
  }

  static Future<List<User>> getUsers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(usersURL),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<bool> createCase(Case newCase) async {
    final token = await getToken();

    final response = await http.post(
      Uri.parse(casesURL),
      body: jsonEncode({
        'name': newCase.name,
        'companyType': newCase.companyType,
        'industry': newCase.industry,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to create case');
    }
  }


  static Future<List<Case>> getAllCases() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(casesURL),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> casesJson = jsonDecode(response.body);
      return casesJson.map((json) => Case.fromJson(json)).toList();
    } else {
      print(response.statusCode);
      throw Exception('Failed to load cases');
    }
  }

  static Future<List<Case>> getMyCases() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(myCasesURL),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> casesJson = jsonDecode(response.body);
      return casesJson.map((json) => Case.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load my cases');
    }
  }

  static Future<List<User>> getUsersByCase(int caseId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$usersByCaseURL/$caseId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users by case');
    }
  }

  static Future<void> addUserToCase(int caseId, {int? userId}) async {
    final token = await getToken();
    String url = userId != null ? '$addUserToCaseURL?userId=$userId' : addUserToCaseURL;

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'caseId': caseId,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to enroll into case');
    }
  }

  static Future<void> removeUserFromCase(int caseId, {int? userId}) async {
    try {
      final token = await getToken();
      String url = userId != null ? '$removeUserFromCaseURL?userId=$userId' : removeUserFromCaseURL;

      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'caseId': caseId,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('User removed from case successfully');
        return;
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        String errorMessage = 'Failed to remove user from case';
        if (errorResponse.containsKey('error')) {
          errorMessage = errorResponse['error'];
        }
        throw Exception(errorMessage);
      } else {
        throw Exception('Failed to remove user from case: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing user from case: $e');
      throw Exception('Failed to remove user from case: $e');
    }
  }
}
