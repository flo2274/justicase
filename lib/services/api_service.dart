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

  static final storage = FlutterSecureStorage();

  static Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse(registerURL),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to register');
    }
  }

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginURL),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await storage.write(key: 'token', value: data['token']);

      // Save username to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', data['user']['username']);

      return true;
    } else {
      print(response.statusCode);
      throw Exception('Failed to login');
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');

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
}
