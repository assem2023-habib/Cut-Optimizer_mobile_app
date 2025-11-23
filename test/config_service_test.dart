import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/services/config_service.dart';
import 'package:cut_optimizer_mobile/models/config.dart';
import 'package:cut_optimizer_mobile/core/enums.dart';
import 'dart:io';

void main() {
  group('ConfigService Tests', () {
    late ConfigService service;
    final String testConfigPath = 'config.json';

    setUp(() {
      service = ConfigService();
      // Ensure clean state
      if (File(testConfigPath).existsSync()) {
        File(testConfigPath).deleteSync();
      }
    });

    tearDown(() {
      if (File(testConfigPath).existsSync()) {
        File(testConfigPath).deleteSync();
      }
    });

    test('Load Config - Default when file missing', () async {
      final config = await service.loadConfig();
      expect(config.minWidth, 370);
      expect(config.selectedMode, GroupingMode.allCombinations);
    });

    test('Save and Load Config', () async {
      final config = Config.defaultConfig();
      config.minWidth = 500;
      config.selectedMode = GroupingMode.noMainRepeat;

      await service.saveConfig(config);

      final loadedConfig = await service.loadConfig();
      expect(loadedConfig.minWidth, 500);
      expect(loadedConfig.selectedMode, GroupingMode.noMainRepeat);
    });

    test('Json Serialization', () {
      final json = {
        "min_width": 370,
        "max_width": 400,
        "tolerance_length": 100,
        "min_total_area": null,
        "max_total_area": null,
        "max_partner": 7,
        "start_with_largest": true,
        "allow_split_rows": true,
        "theme": "dark",
        "background_image": "config\\backgrounds\\img1.jpg",
        "selected_mode": "all combinations",
        "selected_sort_type": "sort carpet by width",
      };

      final config = Config.fromJson(json);
      expect(config.minWidth, 370);
      expect(config.minTotalArea, null);
      expect(config.selectedMode, GroupingMode.allCombinations);

      final jsonOutput = config.toJson();
      expect(jsonOutput['min_width'], 370);
      expect(jsonOutput['selected_mode'], "all combinations");
    });
  });
}
