import 'dart:convert';
import 'dart:io';
import '../models/config.dart';

class ConfigService {
  static const String _configFileName = 'config.json';

  Future<Config> loadConfig() async {
    try {
      final file = File(_configFileName);
      if (await file.exists()) {
        final content = await file.readAsString();
        final json = jsonDecode(content);
        return Config.fromJson(json);
      }
    } catch (e) {
      // Log error or handle it
      print("Error loading config: $e");
    }
    return Config.defaultConfig();
  }

  Future<void> saveConfig(Config config) async {
    try {
      final file = File(_configFileName);
      final json = config.toJson();
      final content = jsonEncode(json);
      await file.writeAsString(content);
    } catch (e) {
      print("Error saving config: $e");
      rethrow;
    }
  }
}
