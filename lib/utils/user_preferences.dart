// user_preferences.dart

import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static Future<void> fetchUserData(Function(int, String, bool) callback) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0;
    String username = prefs.getString('username') ?? '';
    bool isAdmin = prefs.getString('role') == 'admin';
    callback(userId, username, isAdmin);
  }
}
