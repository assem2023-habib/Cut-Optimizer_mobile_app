import 'package:flutter/material.dart';
import '../../../shared/layout/main_layout.dart';
import '../widgets/hero_section.dart';
import '../widgets/quick_stats.dart';
import '../widgets/features_section.dart';
import '../widgets/how_it_works.dart';
import '../widgets/cta_button.dart';
import '../widgets/info_box.dart';

/// الصفحة الرئيسية (Home Screen) - التصميم الجديد
/// 6 أقسام رئيسية: Hero + Stats + Features + How it Works + CTA + Info
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      currentPage: 'home',
      showBottomNav: true,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Hero Section - بطاقة الترحيب مع تدرج أزرق
            HeroSection(),

            SizedBox(height: 16),

            // 2. Quick Stats - إحصائيات سريعة (الكفاءة + توفير الوقت)
            QuickStats(),

            SizedBox(height: 16),

            // 3. Features - الوظائف الرئيسية (3 features)
            FeaturesSection(),

            SizedBox(height: 16),

            // 4. How it Works - 4 خطوات
            HowItWorks(),

            SizedBox(height: 16),

            // 5. CTA Button - زر ابدأ الآن
            CTAButton(),

            SizedBox(height: 16),

            // 6. Info Box - نصيحة
            InfoBox(),

            SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
