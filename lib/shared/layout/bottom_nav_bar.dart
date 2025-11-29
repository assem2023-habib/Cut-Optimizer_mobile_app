import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_routes.dart';

/// شريط التنقل السفلي (Bottom Navigation Bar)
/// يحتوي على 5 أزرار: الرئيسية، رفع، إعدادات، تقارير، إحصائيات
class BottomNavBar extends StatelessWidget {
  final String? currentPage;
  final bool hasProcessedData;

  const BottomNavBar({
    super.key,
    this.currentPage,
    this.hasProcessedData = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.bottomNavHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          top: BorderSide(color: AppColors.gray200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: AppDimensions.shadowBlurRadius,
            offset: const Offset(0, -AppDimensions.shadowOffsetY),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppDimensions.maxAppWidth,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavButton(
                icon: Icons.home,
                label: 'الرئيسية',
                page: AppRoutes.getPageName(AppRoutes.home),
                isActive: currentPage == AppRoutes.getPageName(AppRoutes.home),
                enabled: true,
                onTap: () => _navigate(context, AppRoutes.home),
              ),
              _NavButton(
                icon: Icons.upload_file,
                label: 'رفع',
                page: AppRoutes.getPageName(AppRoutes.upload),
                isActive:
                    currentPage == AppRoutes.getPageName(AppRoutes.upload),
                enabled: true,
                onTap: () => _navigate(context, AppRoutes.upload),
              ),
              _NavButton(
                icon: Icons.settings,
                label: 'إعدادات',
                page: AppRoutes.getPageName(AppRoutes.settings),
                isActive:
                    currentPage == AppRoutes.getPageName(AppRoutes.settings),
                enabled: true,
                onTap: () => _navigate(context, AppRoutes.settings),
              ),
              _NavButton(
                icon: Icons.description,
                label: 'تقارير',
                page: AppRoutes.getPageName(AppRoutes.reports),
                isActive:
                    currentPage == AppRoutes.getPageName(AppRoutes.reports),
                enabled: hasProcessedData,
                onTap: () => _navigate(context, AppRoutes.reports),
              ),
              _NavButton(
                icon: Icons.bar_chart,
                label: 'إحصائيات',
                page: AppRoutes.getPageName(AppRoutes.statistics),
                isActive:
                    currentPage == AppRoutes.getPageName(AppRoutes.statistics),
                enabled: hasProcessedData,
                onTap: () => _navigate(context, AppRoutes.statistics),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}

/// زر التنقل الفردي
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String page;
  final bool isActive;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.page,
    required this.isActive,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Opacity(
          opacity: enabled ? 1.0 : 0.5,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.bottomNavButtonPaddingHorizontal,
              vertical: AppDimensions.bottomNavButtonPaddingVertical,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: AppDimensions.bottomNavIconSize,
                  color: isActive ? AppColors.primary600 : AppColors.gray600,
                ),
                SizedBox(height: AppDimensions.bottomNavIconTextGap),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppDimensions.bottomNavTextSize,
                    color: isActive ? AppColors.primary600 : AppColors.gray600,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
