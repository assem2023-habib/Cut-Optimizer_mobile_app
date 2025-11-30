import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'core/state/app_state_provider.dart';

// Screens
import 'features/home/screens/home_screen.dart';
import 'features/upload/screens/upload_screen.dart';
import 'features/processing/screens/processing_options_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/reports/screens/reports_screen.dart';
import 'features/statistics/screens/statistics_screen.dart';
import 'models/group_carpet.dart';
import 'models/carpet.dart';

import 'models/config.dart';
import 'core/services/config_service.dart';
import 'services/results_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ConfigService and load saved config
  await ConfigService.instance.init();
  final config = await ConfigService.instance.loadConfig();

  // Initialize ResultsStorageService
  await ResultsStorageService.instance.init();

  runApp(MyApp(config: config));
}

class MyApp extends StatelessWidget {
  final Config config;

  const MyApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return AppStateWrapper(
      child: MaterialApp(
        title: 'D',
        debugShowCheckedModeBanner: false,

        // استخدام الثيم الجديد مع خط Cairo
        theme: AppTheme.lightTheme,

        routes: {
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.upload: (context) => const UploadScreen(),
          '/processing-options': (context) =>
              ProcessingOptionsScreen(fileName: 'demo.xlsx', fileSize: 45000),
          AppRoutes.settings: (context) => SettingsScreen(config: config),
          AppRoutes.reports: (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
            return ReportsScreen(
              groups: (args['groups'] as List).cast<GroupCarpet>(),
              remaining: (args['remaining'] as List).cast<Carpet>(),
              originalGroups:
                  (args['originalGroups'] as List?)?.cast<Carpet>() ?? [],
              maxWidth: (args['maxWidth'] as int?) ?? 400,
            );
          },
          AppRoutes.statistics: (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments
                    as Map<String, dynamic>;
            return StatisticsScreen(
              groups: (args['groups'] as List).cast<GroupCarpet>(),
              remaining: (args['remaining'] as List).cast<Carpet>(),
              originalGroups: (args['originalGroups'] as List?)?.cast<Carpet>(),
              maxWidth: (args['maxWidth'] as int?) ?? 400,
            );
          },
        },
      ),
    );
  }
}
