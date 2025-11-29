import 'package:flutter/material.dart';

/// Detailed Stats - الإحصائيات المفصلة
class DetailedStats extends StatelessWidget {
  final double totalArea;
  final double usedArea;
  final double wasteArea;
  final int totalGroups;
  final int totalCuts;
  final double avgPiecesPerGroup;

  const DetailedStats({
    super.key,
    required this.totalArea,
    required this.usedArea,
    required this.wasteArea,
    required this.totalGroups,
    required this.totalCuts,
    required this.avgPiecesPerGroup,
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
            'إحصائيات مفصلة',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          StatRow(
            label: 'المساحة الكلية',
            value: '${totalArea.toStringAsFixed(2)} م²',
          ),
          const SizedBox(height: 8),
          StatRow(
            label: 'المساحة المستخدمة',
            value: '${usedArea.toStringAsFixed(2)} م²',
          ),
          const SizedBox(height: 8),
          StatRow(
            label: 'المساحة المهدرة',
            value: '${wasteArea.toStringAsFixed(2)} م²',
            highlight: true,
          ),
          const SizedBox(height: 8),
          StatRow(label: 'عدد المجموعات', value: '$totalGroups'),
          const SizedBox(height: 8),
          StatRow(label: 'إجمالي القصات', value: '$totalCuts'),
          const SizedBox(height: 8),
          StatRow(
            label: 'متوسط القطع لكل مجموعة',
            value: avgPiecesPerGroup.toStringAsFixed(1),
          ),
        ],
      ),
    );
  }
}

class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFFFF7ED) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: highlight
                  ? const Color(0xFFC2410C)
                  : const Color(0xFF4B5563),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight
                  ? const Color(0xFF9A3412)
                  : const Color(0xFF1F2937),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
