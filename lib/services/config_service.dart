import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/config.dart';

class ConfigService {
  static const String _configFileName = 'config.json';

  Future<String> get _configPath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_configFileName';
  }

  Future<Config> loadConfig() async {
    try {
      final path = await _configPath;
      final file = File(path);
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
      final path = await _configPath;
      final file = File(path);
      final json = config.toJson();
      final content = jsonEncode(json);
      await file.writeAsString(content);
    } catch (e) {
      print("Error saving config: $e");
      rethrow;
    }
  }
}
