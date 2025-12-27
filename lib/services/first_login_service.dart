import 'package:shared_preferences/shared_preferences.dart';
import 'permission_service.dart';

class FirstLoginService {
  static const String _firstLoginKey = 'app_first_login_completed';
  static const String _permissionsRequestedKey = 'app_permissions_requested';

  /// Check if this is the user's first login
  static Future<bool> isFirstLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return !prefs.containsKey(_firstLoginKey);
  }

  /// Check if permissions have been requested
  static Future<bool> havePermissionsBeenRequested() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionsRequestedKey) ?? false;
  }

  /// Mark permissions as requested
  static Future<void> markPermissionsRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionsRequestedKey, true);
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

  /// Reset permissions requested status (for testing purposes)
  static Future<void> resetPermissionsRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_permissionsRequestedKey);
  }

  /// Get first login status
  static Future<Map<String, dynamic>> getFirstLoginStatus() async {
    final isFirst = await isFirstLogin();
    final permissionsRequested = await havePermissionsBeenRequested();
    return {
      'isFirstLogin': isFirst,
      'permissionsRequested': permissionsRequested,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// Check all required permissions status
  static Future<Map<String, bool>> checkAllPermissionsStatus() async {
    return {'storage': await PermissionService.isStoragePermissionGranted()};
  }
}
