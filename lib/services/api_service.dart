import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_anw/models/user.dart';

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

  static Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print('User created successfully: ${response.body}');
    } else {
      print('Failed to create user: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to create user');
    }
  }
}
