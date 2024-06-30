import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/models/case.dart';
import '../utils/validations.dart';

class APIService {
  static const String baseURL = 'http://localhost:3000';
  static const String registerURL = '$baseURL/register';
  static const String loginURL = '$baseURL/login';
  static const String usersURL = '$baseURL/users';
  static const String casesURL = '$baseURL/cases';
  static const String casesByUsersURL = '$baseURL/getcasesbyuser';
  static const String usersByCaseURL = '$baseURL/getusersbycase';
  static const String addUserToCaseURL = '$baseURL/addusertocase';
  static const String removeUserFromCaseURL = '$baseURL/removeuserfromcase';
  static const String deleteUserURL = '$baseURL/deleteuser';
  static const String deleteCaseURL = '$baseURL/deletecase';

  static final storage = FlutterSecureStorage();

  static Future<bool> register(String firstName, String lastName, String username, String email, String password) async {
    if (!Validations.isNotEmpty(firstName)) throw Exception('First name cannot be empty');
    if (!Validations.isNotEmpty(lastName)) throw Exception('Last name cannot be empty');
    if (!Validations.isValidUsername(username)) throw Exception('Invalid username');
    if (!Validations.isValidEmail(email)) throw Exception('Invalid email');
    if (!Validations.isValidPassword(password)) throw Exception('Invalid password');

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
    if (!Validations.isValidEmail(email)) throw Exception('Invalid email');
    if (!Validations.isValidPassword(password)) throw Exception('Invalid password');

    final response = await http.post(
      Uri.parse(loginURL),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data != null && data.containsKey('token') && data['user'] != null && data['user'].containsKey('username') && data['user'].containsKey('role')) {
        final String token = data['token'];
        final int userId = data['user']['id'];
        final String username = data['user']['username'];
        final String role = data['user']['role'];

        await storage.write(key: 'token', value: token);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('userId', userId);
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

  static Future<List<Case>> getCasesByUser({int? userId}) async {
    final token = await getToken();

    String url = casesByUsersURL;
    if (userId != null) {
      url += '?userId=$userId';
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> casesJson = jsonDecode(response.body);
      return casesJson.map((json) => Case.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cases');
    }
  }

  static Future<List<dynamic>> getCasesByIndustry(String industry) async {
    final response = await http.get(Uri.parse('$baseURL/casesbyindustry/$industry'));

    if (response.statusCode == 200) {
      List<dynamic> cases = jsonDecode(response.body);
      return cases;
    } else {
      throw Exception('Failed to load cases by industry');
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
    //String url = userId != null ? '$addUserToCaseURL/$userId' : addUserToCaseURL; So?

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
      final url = Uri.parse(removeUserFromCaseURL);

      final body = {
        'caseId': caseId,
      };

      // Fügt userId hinzu, wenn es nicht null ist
      if (userId != null) {
        body['userId'] = userId;
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
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

  static Future<void> deleteUser(int userId) async {
    try {
      final token = await getToken();

      final response = await http.delete(
        Uri.parse('$deleteUserURL/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('User deleted successfully');
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        String errorMessage = 'Failed to delete user';
        if (errorResponse.containsKey('error')) {
          errorMessage = errorResponse['error'];
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user: $e');
    }
  }

  static Future<void> deleteCase(int caseId) async {
    try {
      final token = await getToken(); // Implement your token retrieval method

      final response = await http.delete(
        Uri.parse('$deleteCaseURL/$caseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Case deleted successfully');
      } else {
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        String errorMessage = 'Failed to delete case';
        if (errorResponse.containsKey('error')) {
          errorMessage = errorResponse['error'];
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print('Error deleting case: $e');
      throw Exception('Failed to delete case: $e');
    }
  }

  static Future<int> getEnrolledUsersCount(int caseId) async {
    try {
      final token = await getToken();

      final response = await http.get(
        Uri.parse('$baseURL/getenrolleduserscount/$caseId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final int count = data['count'];
        return count;
      } else {
        throw Exception('Failed to fetch enrolled users count');
      }
    } catch (e) {
      print('Error fetching enrolled users count: $e');
      throw Exception('Failed to fetch enrolled users count: $e');
    }
  }

  /*static Future<List<Case>> getAllCasesWithEnrolledUsersCount() async {
    try {
      final token = await getToken();

      // Get all cases
      final response = await http.get(
        Uri.parse(casesURL),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> casesJson = jsonDecode(response.body);

        // Create a list to store Case objects with enrolled users count
        List<Case> cases = [];

        // Iterate through each case and fetch enrolled users count
        for (var caseJson in casesJson) {
          Case caseObj = Case.fromJson(caseJson);

          // Get enrolled users count for the current case
          final enrolledUsersCount = await getEnrolledUsersCount(caseObj.id!);
          caseObj.userCount = enrolledUsersCount;

          // Add the updated case object to the list
          cases.add(caseObj);
        }

        return cases;
      } else {
        throw Exception('Failed to load cases');
      }
    } catch (e) {
      print('Error fetching cases with enrolled users count: $e');
      throw Exception('Failed to fetch cases with enrolled users count: $e');
    }
  }*/

}
