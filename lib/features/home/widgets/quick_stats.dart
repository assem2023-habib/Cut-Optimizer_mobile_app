import 'package:flutter/material.dart';

/// القسم 2: Quick Stats - إحصائيات سريعة
/// بطاقتان: الكفاءة (Green) + توفير الوقت (Orange)
class QuickStats extends StatelessWidget {
  const QuickStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // البطاقة 1: الكفاءة
        Expanded(
          child: _StatCard(
            icon: Icons.trending_up,
            iconColor: const Color(0xFF16A34A), // green-600
            label: 'الكفاءة',
            value: 'تصل إلى 95%',
            valueColor: const Color(0xFF16A34A), // green-600
          ),
        ),

        const SizedBox(width: 16), // gap-4
        // البطاقة 2: توفير الوقت
        Expanded(
          child: _StatCard(
            icon: Icons.access_time,
            iconColor: const Color(0xFFEA580C), // orange-600
            label: 'توفير الوقت',
            value: 'سريع وفعال',
            valueColor: const Color(0xFFEA580C), // orange-600
          ),
        ),
      ],
    );
  }
}

/// بطاقة إحصائية واحدة
class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16), // p-4
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), // rounded-xl
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
          // الأيقونة
          Icon(
            icon,
            color: iconColor,
            size: 20, // w-5 h-5
          ),

          const SizedBox(height: 8),

          // التسمية
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF4B5563), // gray-600
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 4),

          // القيمة
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
