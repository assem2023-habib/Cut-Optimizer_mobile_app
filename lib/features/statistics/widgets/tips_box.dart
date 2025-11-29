import 'package:flutter/material.dart';

/// Tips Box - صندوق النصائح
class TipsBox extends StatelessWidget {
  const TipsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('💡 ', style: TextStyle(fontSize: 18)),
              Text(
                'نصائح للتحسين',
                style: TextStyle(
                  color: Color(0xFF1E40AF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          TipItem('جرب تعديل قيم الحد الأدنى والأقصى للعرض'),
          TipItem('زيادة التسامح قد تسمح بدمج المزيد من القطع'),
          TipItem('تجميع الطلبات المتشابهة يحسن الكفاءة'),
        ],
      ),
    );
  }
}

class TipItem extends StatelessWidget {
  final String text;

  const TipItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: Color(0xFF1D4ED8), fontSize: 16),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Color(0xFF1D4ED8), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
