import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';

// Screens
import 'features/home/screens/home_screen.dart';
import 'features/upload/screens/upload_screen.dart';
import 'features/processing/screens/processing_options_screen.dart';
import 'features/settings/screens/settings_screen.dart';

import 'models/config.dart';
import 'core/services/config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ConfigService and load saved config
  await ConfigService.instance.init();
  final config = await ConfigService.instance.loadConfig();

  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final Config config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام تحسين قص السجاد',
      debugShowCheckedModeBanner: false,

      // استخدام الثيم الجديد مع خط Cairo
      theme: AppTheme.lightTheme,

      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.upload: (context) => const UploadScreen(),
        '/processing-options': (context) =>
            ProcessingOptionsScreen(fileName: 'demo.xlsx', fileSize: 45000),
        AppRoutes.settings: (context) => SettingsScreen(config: config),
      },
    );
  }
}
