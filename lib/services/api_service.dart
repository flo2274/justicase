import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_anw/utils/user_preferences.dart';
import 'package:mobile_anw/models/user.dart';
import 'package:mobile_anw/models/case.dart';
import 'package:mobile_anw/models/chat_message.dart';
import 'package:mobile_anw/services/api_config.dart';
import '../utils/validations.dart';

class APIService {

  static const storage = FlutterSecureStorage();

  static Future<bool> register(String firstName, String lastName, String username, String email, String password) async {
    if (!Validations.isNotEmpty(firstName)) throw 'Vorname darf nicht leer sein';
    if (!Validations.isNotEmpty(lastName)) throw 'Nachname darf nicht leer sein';
    if (!Validations.isValidUsername(username)) throw 'Ungültiger Benutzername';
    if (!Validations.isValidEmail(email)) throw 'Ungültige E-Mail-Adresse';
    if (!Validations.isValidPassword(password)) throw 'Ungültiges Passwort';

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.registerURL),
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
        final Map<String, dynamic> errorResponse = jsonDecode(response.body);
        String errorMessage = 'Registrierung fehlgeschlagen: ';
        if (errorResponse.containsKey('errors')) {
          errorMessage += errorResponse['errors'].join('\n');
        } else if (errorResponse.containsKey('message')) {
          errorMessage += errorResponse['message'];
        }
        throw errorMessage;
      } else {
        throw 'Registrierung fehlgeschlagen: ${response.statusCode}';
      }
    } catch (e) {
      throw 'Registrierung fehlgeschlagen: $e';
    }
  }

  static Future<bool> login(String email, String password) async {
    if (!Validations.isValidEmail(email)) throw Exception('Ungültige E-Mail-Adresse');
    if (!Validations.isValidPassword(password)) throw Exception('Ungültiges Passwort');

    final response = await http.post(
      Uri.parse(ApiConfig.loginURL),
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

        await UserPreferences.saveUserData(token, userId, username, role);

        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  static Future<void> logout() async {
    await UserPreferences.removeUserData();
  }

  static Future<List<User>> getUsers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(ApiConfig.usersURL),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Fehler beim Laden der Benutzer');
    }
  }

  static Future<bool> createCase(Case newCase) async {
    final token = await getToken();

    final response = await http.post(
      Uri.parse(ApiConfig.casesURL),
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
      throw Exception('Fehler beim Erstellen des Falls');
    }
  }

  static Future<List<Case>> getAllCases() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse(ApiConfig.casesURL),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> casesJson = jsonDecode(response.body);
      return casesJson.map((json) => Case.fromJson(json)).toList();
    } else {
      throw Exception('Fehler beim Laden der Fälle');
    }
  }

  static Future<List<Case>> getCasesByUser({int? userId}) async {
    final token = await getToken();

    String url = ApiConfig.casesByUsersURL;
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
      throw Exception('Fehler beim Laden der Fälle');
    }
  }

  static Future<List<dynamic>> getCasesByIndustry(String industry) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${ApiConfig.casesURL}/industry?industry=$industry'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> cases = jsonDecode(response.body);
      return cases;
    } else {
      throw Exception('Fehler beim Laden der Fälle nach Branche');
    }
  }

  static Future<List<User>> getUsersByCase(int caseId) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${ApiConfig.usersByCaseURL}/$caseId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Fehler beim Laden der Benutzer für den Fall');
    }
  }

  static Future<void> addUserToCase(int caseId, {int? userId}) async {
    final token = await getToken();
    String url = '${ApiConfig.casesURL}/$caseId/user';
    if (userId != null) {
      url += '?userId=$userId';
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Fehler beim Hinzufügen des Benutzers zum Fall');
    }
  }

  static Future<void> removeUserFromCase(int caseId, {int? userId}) async {
    final token = await getToken();
    String url = '${ApiConfig.casesURL}/$caseId/user';

    if (userId != null) {
      url += '?userId=$userId';
    }

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Fehler beim Entfernen des Benutzers aus dem Fall');
    }
  }

  static Future<void> deleteUser(int userId) async {
    final token = await getToken();

    final response = await http.delete(
      Uri.parse('${ApiConfig.usersURL}/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Fehler beim Löschen des Benutzers');
    }
  }

  static Future<void> deleteCase(int caseId) async {
    final token = await getToken();

    final response = await http.delete(
      Uri.parse('${ApiConfig.casesURL}/$caseId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Fehler beim Löschen des Falls');
    }
  }

  static Future<int> getEnrolledUsersCount(int caseId) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.casesURL}/$caseId/count/users'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final int count = data['count'];
        return count;
      } else {
        throw Exception('Fehler beim Abrufen der Anzahl der eingeschriebenen Benutzer');
      }
    } catch (e) {
      throw Exception('Fehler beim Abrufen der Anzahl der eingeschriebenen Benutzer: $e');
    }
  }

  static Future<List<Case>> fetchCasesWithMostEnrolledUsers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${ApiConfig.casesURL}/most-enrolled'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Case.fromJson(data)).toList();
    } else {
      throw Exception('Fehler beim Laden der vorgeschlagenen Fälle');
    }
  }

  static Future<List<ChatMessage>> getMessagesFromCase(int caseId) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.casesURL}/$caseId/messages'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> messagesJson = jsonDecode(response.body);
        return messagesJson.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception('Fehler beim Laden der Chat-Nachrichten: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fehler beim Laden der Chat-Nachrichten');
    }
  }

  static Future<bool> sendMessageToCase(int caseId, ChatMessage message) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('${ApiConfig.casesURL}/$caseId/messages'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'text': message.text,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Fehler beim Senden der Chat-Nachricht');
    }
  }

  static Future<List<Case>> getCasesWithMostEnrolledUsers() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('${ApiConfig.casesURL}/most-enrolled'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Case.fromJson(data)).toList();
    } else {
      throw Exception('Fehler beim Laden der Fälle mit den meisten eingeschriebenen Benutzern');
    }
  }
}
