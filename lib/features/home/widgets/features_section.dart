import 'package:flutter/material.dart';

/// القسم 3: Features - الوظائف الرئيسية
/// 3 ميزات: استيراد Excel + تجميع ذكي + تحليل شامل
class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // p-4
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // rounded-xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الميزة 1: استيراد من Excel
          _FeatureItem(
            icon: Icons.table_chart,
            iconColor: const Color(0xFF2563EB), // blue-600
            title: 'استيراد من Excel',
            description: 'قم برفع ملف Excel يحتوي على طلبات العملاء بكل سهولة',
          ),

          // خط فاصل
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 1,
            color: const Color(0xFFF3F4F6), // gray-100
          ),

          // الميزة 2: تجميع ذكي
          _FeatureItem(
            icon: Icons.content_cut,
            iconColor: const Color(0xFF9333EA), // purple-600
            title: 'تجميع ذكي',
            description: 'نظام متقدم لتجميع القطع بأفضل طريقة ممكنة',
          ),

          // خط فاصل
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: 1,
            color: const Color(0xFFF3F4F6), // gray-100
          ),

          // الميزة 3: تحليل شامل
          _FeatureItem(
            icon: Icons.trending_up,
            iconColor: const Color(0xFF16A34A), // green-600
            title: 'تحليل شامل',
            description: 'احصل على تقارير مفصلة وإحصائيات دقيقة عن نتائج القص',
          ),
        ],
      ),
    );
  }
}

/// عنصر ميزة واحد
class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الأيقونة
        Icon(
          icon,
          color: iconColor,
          size: 20, // w-5 h-5
        ),

        const SizedBox(width: 12),

        // النص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF1F2937), // gray-800
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 4),

              // الوصف
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF6B7280), // gray-500
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
