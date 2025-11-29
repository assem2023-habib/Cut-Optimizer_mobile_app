import 'package:flutter/material.dart';

/// القسم 6: Info Box - صندوق النصيحة
/// خلفية Blue-50 مع حدود Blue-200
class InfoBox extends StatelessWidget {
  const InfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // p-4
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // blue-50
        border: Border.all(
          color: const Color(0xFFBFDBFE), // blue-200
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12), // rounded-xl
      ),
      child: RichText(
        text: const TextSpan(
          style: TextStyle(
            color: Color(0xFF1E40AF), // blue-800
            fontSize: 14,
            height: 1.625, // leading-relaxed
          ),
          children: [
            TextSpan(text: '💡 ', style: TextStyle(fontSize: 16)),
            TextSpan(
              text: 'نصيحة: ',
              style: TextStyle(
                fontWeight: FontWeight.w600, // font-semibold
              ),
            ),
            TextSpan(
              text:
                  'تأكد من أن ملف Excel يحتوي على الأعمدة المطلوبة بالترتيب الصحيح '
                  '(رقم الطلب، العرض، الطول، الكمية، نوع القطعة، نوع النسيج، كود التحضير) '
                  'لضمان أفضل النتائج.',
            ),
          ],
        ),
      ),
    );
  }
}
