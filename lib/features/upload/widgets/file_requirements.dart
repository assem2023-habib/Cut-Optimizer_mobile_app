import 'package:flutter/material.dart';
import 'requirement_item.dart';

/// قائمة متطلبات الملف
const requirements = [
  'الملف مع ترويسة في الصف الأول',
  'العمود A: رقم طلب العميل',
  'العمود B: العرض (Width)',
  'العمود C: الطول (Height)',
  'العمود D: الكمية (Qty)',
  'العمود E: نوع القطعة (A للأزواج)',
  'العمود F: نوع النسيج (B للتدوير)',
  'العمود G: كود التحضير (A/B/C/D)',
];

/// متطلبات الملف
class FileRequirements extends StatelessWidget {
  const FileRequirements({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // العنوان
          const Row(
            children: [
              Icon(
                Icons.table_chart,
                size: 20,
                color: Color(0xFF2563EB), // blue-600
              ),
              SizedBox(width: 8),
              Text(
                'متطلبات الملف',
                style: TextStyle(
                  color: Color(0xFF1F2937), // gray-800
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // المتطلبات
          ...requirements.map((req) => RequirementItem(text: req)),
        ],
      ),
    );
  }
}
