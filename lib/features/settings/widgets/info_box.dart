import 'package:flutter/material.dart';

/// Info Box - صندوق المعلومات
class SettingsInfoBox extends StatelessWidget {
  const SettingsInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // blue-50
        border: Border.all(color: const Color(0xFFBFDBFE)), // blue-200
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(
            color: Color(0xFF1E40AF), // blue-800
            fontSize: 14,
            height: 1.625,
          ),
          children: [
            TextSpan(text: '💡 '),
            TextSpan(
              text: 'نصيحة: ',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text:
                  'يتم حفظ الإعدادات تلقائياً على جهازك ولن تحتاج لإعادة إدخالها في المرة القادمة.',
            ),
          ],
        ),
      ),
    );
  }
}
