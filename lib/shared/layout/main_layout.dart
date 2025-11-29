import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import 'app_header.dart';
import 'bottom_nav_bar.dart';

/// البنية الرئيسية للتطبيق (Main Layout)
/// يحتوي على: Header (ثابت) + Content (ديناميكي) + Bottom Navigation (ثابت)
class MainLayout extends StatelessWidget {
  /// محتوى الصفحة الديناميكي
  final Widget child;

  /// اسم الصفحة الحالية (لتحديد الزر النشط في Bottom Nav)
  final String? currentPage;

  /// هل نعرض Bottom Navigation؟ (نخفيه في صفحة Processing)
  final bool showBottomNav;

  /// هل توجد بيانات معالجة؟ (لتفعيل أزرار التقارير والإحصائيات)
  final bool hasProcessedData;

  const MainLayout({
    super.key,
    required this.child,
    this.currentPage,
    this.showBottomNav = true,
    this.hasProcessedData = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl, // RTL للعربية
        child: Column(
          children: [
            // ========== Header الثابت ==========
            const AppHeader(),

            // ========== المحتوى الديناميكي ==========
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppDimensions.maxAppWidth,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: showBottomNav
                          ? AppDimensions.contentPaddingBottom
                          : 0,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),

            // ========== Bottom Navigation الثابت ==========
            // يختفي في صفحة Processing
            if (showBottomNav && currentPage != 'processing')
              BottomNavBar(
                currentPage: currentPage,
                hasProcessedData: hasProcessedData,
              ),
          ],
        ),
      ),
    );
  }
}
