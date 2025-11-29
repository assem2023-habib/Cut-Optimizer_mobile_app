import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';

// Screens
import 'features/home/screens/home_screen.dart';
import 'features/upload/screens/upload_screen.dart';
import 'features/processing/screens/processing_options_screen.dart';
import 'features/processing/screens/processing_loader_screen.dart';
import 'features/results/screens/results_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/reports/screens/reports_screen.dart';
import 'features/statistics/screens/statistics_screen.dart';
import 'models/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نظام تحسين قص السجاد',
      debugShowCheckedModeBanner: false,

      // استخدام الثيم الجديد مع خط Cairo
      theme: AppTheme.lightTheme,

      // Home screen الجديدة
      home: const HomeScreen(),

      // Routes للتنقل بين الصفحات
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.upload: (context) => const UploadScreen(),
        '/processing-options': (context) =>
            ProcessingOptionsScreen(fileName: 'demo.xlsx', fileSize: 45000),
        '/processing': (context) => const ProcessingLoaderScreen(),
        AppRoutes.settings: (context) =>
            SettingsScreen(config: Config.defaultConfig()),
      },
    );
  }
}
