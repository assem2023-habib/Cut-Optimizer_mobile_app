import 'package:flutter/material.dart';

/// Key Metrics - 4 بطاقات المؤشرات الرئيسية
class KeyMetrics extends StatelessWidget {
  final double efficiency;
  final double usedArea;
  final double wastePercentage;
  final int totalGroups;

  const KeyMetrics({
    super.key,
    required this.efficiency,
    required this.usedArea,
    required this.wastePercentage,
    required this.totalGroups,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        MetricCard(
          icon: Icons.trending_up,
          iconColor: const Color(0xFF16A34A),
          label: 'الكفاءة',
          value: '${efficiency.toStringAsFixed(2)}%',
          bgColor: const Color(0xFFF0FDF4),
          borderColor: const Color(0xFFBBF7D0),
        ),
        MetricCard(
          icon: Icons.show_chart,
          iconColor: const Color(0xFF2563EB),
          label: 'المساحة المستخدمة',
          value: '${usedArea.toStringAsFixed(2)} م²',
          bgColor: const Color(0xFFEFF6FF),
          borderColor: const Color(0xFFBFDBFE),
        ),
        MetricCard(
          icon: Icons.pie_chart,
          iconColor: const Color(0xFFEA580C),
          label: 'نسبة الهادر',
          value: '${wastePercentage.toStringAsFixed(2)}%',
          bgColor: const Color(0xFFFFF7ED),
          borderColor: const Color(0xFFFED7AA),
        ),
        MetricCard(
          icon: Icons.bar_chart,
          iconColor: const Color(0xFF9333EA),
          label: 'المجموعات',
          value: '$totalGroups',
          bgColor: const Color(0xFFFAF5FF),
          borderColor: const Color(0xFFE9D5FF),
        ),
      ],
    );
  }
}

class MetricCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color bgColor;
  final Color borderColor;

  const MetricCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xFF4B5563), fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
