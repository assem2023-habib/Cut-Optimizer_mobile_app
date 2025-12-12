import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'core/state/app_state_provider.dart';
import 'core/providers/config_provider.dart';

// Screens
import 'features/home/screens/home_screen_wrapper.dart';
import 'features/upload/screens/upload_screen.dart';
import 'features/processing/screens/processing_options_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/reports/screens/reports_screen.dart';
import 'features/statistics/screens/statistics_screen.dart';
import 'features/results/screens/results_screen.dart';
import 'features/checker/screens/checker_screen.dart';
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
    return ValueListenableBuilder<Config>(
      valueListenable: ConfigService.instance.configNotifier,
      builder: (context, currentConfig, child) {
        return ConfigProvider(
          config: currentConfig,
          child: AppStateWrapper(
            child: MaterialApp(
              title: 'سجادي',
              debugShowCheckedModeBanner: false,

              // استخدام الثيم الجديد مع خط Cairo
              theme: AppTheme.lightTheme,

              routes: {
                AppRoutes.home: (context) => const HomeScreenWrapper(),
                AppRoutes.upload: (context) => const UploadScreen(),
                AppRoutes.checker: (context) => const CheckerScreen(),
                '/processing-options': (context) {
                  final args =
                      ModalRoute.of(context)!.settings.arguments
                          as Map<String, dynamic>;
                  return ProcessingOptionsScreen(
                    fileName: args['fileName'] as String,
                    fileSize: args['fileSize'] as int,
                    filePath: args['filePath'] as String?,
                    config: currentConfig,
                  );
                },
                AppRoutes.settings: (context) =>
                    SettingsScreen(config: currentConfig),
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
                    originalGroups: (args['originalGroups'] as List?)
                        ?.cast<Carpet>(),
                    maxWidth: (args['maxWidth'] as int?) ?? 400,
                  );
                },
                AppRoutes.results: (context) {
                  final appState = AppStateProvider.of(context);
                  final config = ConfigProvider.of(context);

                  // Ensure we have data before showing results
                  if (!appState.hasProcessedData) {
                    // Redirect to home if no data
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(AppRoutes.home);
                    });
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return ResultsScreen(
                    groups: appState.groups!,
                    remaining: appState.remaining!,
                    originalGroups: appState.originalGroups,
                    suggestedGroups: appState.suggestedGroups,
                    outputFilePath: appState.outputFilePath ?? '',
                    minWidth: appState.minWidth ?? 0,
                    maxWidth: appState.maxWidth ?? 0,
                    tolerance: appState.tolerance ?? 0,
                    config: config!,
                  );
                },
              },
            ),
          ),
        );
      },
    );
  }
}
