import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/// Efficiency Chart - الرسم الدائري للكفاءة
class EfficiencyChart extends StatelessWidget {
  final double efficiency;
  final double wastePercentage;

  const EfficiencyChart({
    super.key,
    required this.efficiency,
    required this.wastePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            'توزيع الكفاءة',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: efficiency,
                    title: 'مستخدم\n${efficiency.toStringAsFixed(1)}%',
                    color: const Color(0xFF10B981),
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: wastePercentage,
                    title: 'هادر\n${wastePercentage.toStringAsFixed(1)}%',
                    color: const Color(0xFFF59E0B),
                    radius: 80,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LegendItem(
                color: const Color(0xFF10B981),
                label: 'مستخدم (${efficiency.toStringAsFixed(1)}%)',
              ),
              const SizedBox(width: 24),
              LegendItem(
                color: const Color(0xFFF59E0B),
                label: 'هادر (${wastePercentage.toStringAsFixed(1)}%)',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
