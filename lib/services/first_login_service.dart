import 'package:shared_preferences/shared_preferences.dart';

class FirstLoginService {
  static const String _firstLoginKey = 'app_first_login_completed';

  /// Check if this is the user's first login
  static Future<bool> isFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey(_firstLoginKey);
  }

  /// Mark first login as completed
  static Future<void> markFirstLoginCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLoginKey, true);
  }

  /// Reset first login status (for testing purposes)
  static Future<void> resetFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_firstLoginKey);
  }

  /// Get first login status
  static Future<Map<String, dynamic>> getFirstLoginStatus() async {
    final isFirst = await isFirstLogin();
    return {
      'isFirstLogin': isFirst,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
