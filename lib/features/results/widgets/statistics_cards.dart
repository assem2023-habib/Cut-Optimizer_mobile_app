import 'package:flutter/material.dart';

/// Statistics Cards
class StatisticsCards extends StatelessWidget {
  final double efficiency;
  final double wastePercentage;
  final int totalGroups;
  final int totalCuts;

  const StatisticsCards({
    super.key,
    required this.efficiency,
    required this.wastePercentage,
    required this.totalGroups,
    required this.totalCuts,
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
        _StatCard(
          icon: Icons.trending_up,
          iconColor: const Color(0xFF16A34A),
          label: 'الكفاءة',
          value: '${efficiency.toStringAsFixed(1)}%',
          bgColor: const Color(0xFFF0FDF4),
          borderColor: const Color(0xFFBBF7D0),
        ),
        _StatCard(
          icon: Icons.warning,
          iconColor: const Color(0xFFEA580C),
          label: 'الهادر',
          value: '${wastePercentage.toStringAsFixed(1)}%',
          bgColor: const Color(0xFFFFF7ED),
          borderColor: const Color(0xFFFED7AA),
        ),
        _StatCard(
          icon: Icons.inventory_2,
          iconColor: const Color(0xFF2563EB),
          label: 'المجموعات',
          value: '$totalGroups',
          bgColor: const Color(0xFFEFF6FF),
          borderColor: const Color(0xFFBFDBFE),
        ),
        _StatCard(
          icon: Icons.description,
          iconColor: const Color(0xFF9333EA),
          label: 'القصات',
          value: '$totalCuts',
          bgColor: const Color(0xFFFAF5FF),
          borderColor: const Color(0xFFE9D5FF),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color bgColor;
  final Color borderColor;

  const _StatCard({
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
