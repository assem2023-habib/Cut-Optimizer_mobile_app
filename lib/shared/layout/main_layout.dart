import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/state/app_state_provider.dart';
import '../../core/providers/config_provider.dart';
import '../../services/background_service.dart';
import 'app_header.dart';
import 'bottom_nav_bar.dart';
import '../widgets/results_floating_button.dart';

/// البنية الرئيسية للتطبيق (Main Layout)
/// يحتوي على: Header (ثابت) + Content (ديناميكي) + Bottom Navigation (ثابت)
class MainLayout extends StatelessWidget {
  /// محتوى الصفحة الديناميكي
  final Widget child;

  /// اسم الصفحة الحالية (لتحديد الزر النشط في Bottom Nav)
  final String? currentPage;

  /// هل نعرض Bottom Navigation؟ (نخفيه في صفحة Processing)
  final bool showBottomNav;

  const MainLayout({
    super.key,
    required this.child,
    this.currentPage,
    this.showBottomNav = true,
  });

  @override
  Widget build(BuildContext context) {
    // الوصول للحالة المشتركة
    final appState = AppStateProvider.of(context);

    // Get config from ConfigProvider
    final config = ConfigProvider.of(context);

    // Get background decoration from config
    final BoxDecoration? backgroundDecoration = config != null
        ? BackgroundService.getBackgroundDecoration(config.backgroundImage)
        : null;

    return Scaffold(
      body: Container(
        decoration:
            backgroundDecoration ?? BoxDecoration(color: AppColors.background),
        child: Directionality(
          textDirection: TextDirection.rtl, // RTL للعربية
          child: Stack(
            children: [
              // ========== المحتوى الديناميكي ==========
              Column(
                children: [
                  // ========== Header الثابت ==========
                  const AppHeader(),

                  // ========== المحتوى القابل للتمرير ==========
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppDimensions.maxAppWidth,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),

              // ========== Bottom Navigation الثابت ==========
              // يختفي في صفحة Processing
              if (showBottomNav && currentPage != 'processing')
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BottomNavBar(
                    currentPage: currentPage,
                    hasProcessedData: appState.hasProcessedData,
                    groups: appState.groups,
                    remaining: appState.remaining,
                    originalGroups: appState.originalGroups,
                  ),
                ),

              // ========== Floating Action Button ==========
              // يظهر في جميع الشاشات ما عدا النتائج والمعالجة
              if (currentPage != 'results' && currentPage != 'processing')
                const Positioned(
                  bottom: 100, // ارتفاع الناف بار + مسافة
                  left: 20,
                  child: ResultsFloatingButton(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
