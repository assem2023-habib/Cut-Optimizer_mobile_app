import 'package:flutter/material.dart';

/// القسم 3: أكواد التحضير
class PrepCodes extends StatelessWidget {
  const PrepCodes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFFAF5FF), // purple-50
            Color(0xFFEFF6FF), // blue-50
          ],
        ),
        border: Border.all(color: const Color(0xFFE9D5FF)), // purple-200
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'أكواد التحضير',
            style: TextStyle(
              color: Color(0xFF6B21A8), // purple-800
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          ..._prepCodesData.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: PrepCodeInfo(code: entry.key, addition: entry.value),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'ملاحظة: يتم إضافة القيمة المحددة للطول المطلوب',
            style: TextStyle(
              color: Color(0xFF7E22CE), // purple-700
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

const _prepCodesData = {'A': '+8 سم', 'B': '+6 سم', 'C': '+1 سم', 'D': '+3 سم'};

/// معلومات كود تحضير واحد
class PrepCodeInfo extends StatelessWidget {
  final String code;
  final String addition;

  const PrepCodeInfo({super.key, required this.code, required this.addition});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // المربع
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF9333EA), // purple-600
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                code,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Text(
            'كود $code',
            style: const TextStyle(
              color: Color(0xFF6B21A8), // purple-800
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          Text(
            addition,
            style: const TextStyle(
              color: Color(0xFF7E22CE), // purple-700
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
