import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Header (الرأس) الثابت للتطبيق
/// يظهر في أعلى جميع الشاشات
/// التصميم: تدرج أزرق من اليمين لليسار (RTL)
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.headerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.headerGradient),
      child: SafeArea(
        bottom: false, // نحتاج SafeArea فقط للأعلى
        child: Stack(
          children: [
            Center(
              child: Text(
                '',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppDimensions.headerFontSize,
                  fontWeight: FontWeight.bold,
                  height: 1.2, // Line height
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 16, // RTL: Left is the trailing side
              top: 0,
              bottom: 0,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/settings');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
