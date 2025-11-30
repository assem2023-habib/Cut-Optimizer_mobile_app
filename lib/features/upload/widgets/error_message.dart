import 'package:flutter/material.dart';

/// رسالة الخطأ
class ErrorMessage extends StatelessWidget {
  final String error;

  const ErrorMessage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), // red-50
        border: Border.all(color: const Color(0xFFFECACA)), // red-200
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2), // mt-0.5
            child: Icon(
              Icons.error_outline,
              size: 20,
              color: Color(0xFFDC2626), // red-600
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFB91C1C), // red-700
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
