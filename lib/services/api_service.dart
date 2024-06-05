import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_anw/models/user.dart';

class APIService {
  static const String baseURL = 'http://localhost:3000';
  static const String registerURL = '$baseURL/register';
  static const String loginURL = '$baseURL/login';
  static const String usersURL = '$baseURL/users';
  static const String casesURL = '$baseURL/cases';

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
    await storage.delete(key: 'token');
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

  static Future<bool> createCase(String name, String companyType, String industry) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse(casesURL),
      body: jsonEncode({
        'name': name,
        'companyType': companyType,
        'industry': industry,
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
}

/*
class ApiService {
  static const String baseUrl = 'http://192.168.2.100:3000';

  static Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<void> createUser(String username, String password,
      String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('User created successfully: ${response.body}');
    } else {
      print('Failed to create user: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create user');
    }
  }
}*/
