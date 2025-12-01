import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/config.dart';

class ConfigService {
  static const String _configKey = 'app_config';
  static SharedPreferences? _prefs;

  // Private constructor
  ConfigService._();

  // Singleton instance
  static final ConfigService instance = ConfigService._();

  // Config Notifier for reactive updates
  final ValueNotifier<Config> configNotifier = ValueNotifier(
    Config.defaultConfig(),
  );

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Load initial config into notifier
    configNotifier.value = await loadConfig();
  }

  /// Save Config to persistent storage
  Future<bool> saveConfig(Config config) async {
    if (_prefs == null) await init();
    try {
      final String jsonString = jsonEncode(config.toJson());
      final result = await _prefs!.setString(_configKey, jsonString);
      if (result) {
        configNotifier.value = config; // Update notifier
      }
      return result;
    } catch (e) {
      debugPrint('Error saving config: $e');
      return false;
    }
  }

  /// Load Config from persistent storage
  /// Returns default config if no saved data exists
  Future<Config> loadConfig() async {
    if (_prefs == null) await init();
    try {
      final String? jsonString = _prefs!.getString(_configKey);
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return Config.fromJson(jsonMap);
      }
    } catch (e) {
      debugPrint('Error loading config: $e');
    }
    return Config.defaultConfig();
  }
}
