import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const storage = FlutterSecureStorage();

  static Future<void> saveUserData(String token, int userId, String username, String role) async {
    await storage.write(key: 'token', value: token);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
    await prefs.setString('username', username);
    await prefs.setString('role', role);
  }

  static Future<void> fetchUserData(Function(int, String, bool) callback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0;
    String username = prefs.getString('username') ?? '';
    bool isAdmin = prefs.getString('role') == 'admin';
    callback(userId, username, isAdmin);
  }

  static Future<void> removeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('id');
    await prefs.remove('username');
    await prefs.remove('role');
  }
}
