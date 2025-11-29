import 'package:flutter/material.dart';

/// القسم 4: How it Works - كيف يعمل
/// 4 خطوات مع أرقام دائرية زرقاء
class HowItWorks extends StatelessWidget {
  const HowItWorks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'كيف يعمل؟',
            style: TextStyle(
              color: Color(0xFF1F2937), // gray-800
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          // الخطوات
          _StepItem(
            number: '1',
            text: 'ارفع ملف Excel يحتوي على طلبات العملاء',
          ),

          const SizedBox(height: 8),

          _StepItem(number: '2', text: 'اضبط الإعدادات حسب احتياجاتك'),

          const SizedBox(height: 8),

          _StepItem(number: '3', text: 'اضغط على معالجة وانتظر النتائج'),

          const SizedBox(height: 8),

          _StepItem(number: '4', text: 'استعرض التقارير والإحصائيات المفصلة'),
        ],
      ),
    );
  }
}

/// عنصر خطوة واحد
class _StepItem extends StatelessWidget {
  final String number;
  final String text;

  const _StepItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12), // p-3
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // rounded-lg
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الدائرة المرقمة
          Container(
            width: 24, // w-6
            height: 24, // h-6
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB), // blue-600
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12), // gap-3
          // النص
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2), // pt-0.5 للمحاذاة
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF374151), // gray-700
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
