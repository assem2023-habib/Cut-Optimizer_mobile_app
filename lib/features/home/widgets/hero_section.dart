import 'package:flutter/material.dart';

/// القسم 1: Hero Section - بطاقة الترحيب
/// التدرج: من Blue-500 (#3B82F6) إلى Blue-600 (#2563EB)
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3B82F6), // blue-500
            Color(0xFF2563EB), // blue-600
          ],
        ),
        borderRadius: BorderRadius.circular(16), // rounded-2xl
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24), // p-6
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الأيقونة الزجاجية (Glassmorphism)
          Container(
            padding: const EdgeInsets.all(12), // p-3
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2), // bg-white/20
              borderRadius: BorderRadius.circular(12), // rounded-xl
              // backdrop-blur-sm effect
            ),
            child: const Icon(
              Icons.content_cut, // Scissors icon
              color: Colors.white,
              size: 32, // w-8 h-8
            ),
          ),

          const SizedBox(height: 20),

          // العنوان
          const Text(
            'نظام تحسين قص السجاد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // النص الفرعي
          const Text(
            'أفضل وأسرع',
            style: TextStyle(
              color: Color(0xFFDBEAFE), // blue-100
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 12),

          // الوصف
          const Text(
            'نظام ذكي لتحسين عملية القص وتقليل الهدر بكفاءة عالية، مع تحليل شامل للبيانات وإنتاج تقارير دقيقة.',
            style: TextStyle(
              color: Color(0xFFEFF6FF), // blue-50
              fontSize: 14,
              height: 1.625, // leading-relaxed
            ),
          ),
        ],
      ),
    );
  }
}
