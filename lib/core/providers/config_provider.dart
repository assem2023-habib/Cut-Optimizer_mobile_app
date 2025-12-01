import 'package:flutter/material.dart';
import '../../models/config.dart';

/// Config Provider - InheritedWidget لتوفير Config لجميع الشاشات
class ConfigProvider extends InheritedWidget {
  final Config config;

  const ConfigProvider({super.key, required this.config, required super.child});

  static Config? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ConfigProvider>()?.config;
  }

  @override
  bool updateShouldNotify(ConfigProvider oldWidget) {
    return config != oldWidget.config;
  }
}
