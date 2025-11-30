import 'package:flutter/material.dart';

/// الحالة الفارغة لمنطقة الرفع
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // أيقونة Upload في دائرة
        Container(
          padding: const EdgeInsets.all(16), // p-4
          decoration: const BoxDecoration(
            color: Color(0xFFDBEAFE), // blue-100
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.upload_file,
            size: 32, // w-8 h-8
            color: Color(0xFF2563EB), // blue-600
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'اضغط لاختيار ملف',
          style: TextStyle(
            color: Color(0xFF374151), // gray-700
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Excel (.xlsx, .xls)',
          style: TextStyle(
            color: Color(0xFF6B7280), // gray-500
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
