import 'package:flutter/material.dart';

/// عنصر متطلب واحد
class RequirementItem extends StatelessWidget {
  final String text;

  const RequirementItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // النقطة
          Container(
            width: 6, // w-1.5
            height: 6, // h-1.5
            margin: const EdgeInsets.only(top: 8), // mt-2
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB), // blue-600
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 8),

          // النص
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF374151), // gray-700
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
