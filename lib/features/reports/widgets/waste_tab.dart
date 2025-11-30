import 'package:flutter/material.dart';
import '../../../models/group_carpet.dart';
import '../../../models/carpet_used.dart';

/// Tab 4: الهادر
class WasteTab extends StatelessWidget {
  final List<GroupCarpet> groups;

  const WasteTab({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...groups.asMap().entries.map((entry) {
          final group = entry.value;
          final totalArea = (group.totalWidth * group.maxHeight).toDouble();
          final usedArea = group.items.fold(
            0.0,
            (sum, item) => sum + (item.width * item.height * item.qtyUsed),
          );
          final wasteArea = totalArea - usedArea;
          final wastePercentage = totalArea > 0
              ? (wasteArea / totalArea) * 100
              : 0.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _WasteCard(
              groupId: group.groupId,
              totalArea: totalArea,
              usedArea: usedArea,
              wasteArea: wasteArea,
              wastePercentage: wastePercentage,
            ),
          );
        }).toList(),
        // مسافة إضافية لتجنب تداخل مع BottomNavBar
        const SizedBox(height: 80),
      ],
    );
  }
}

class _WasteCard extends StatelessWidget {
  final int groupId;
  final double totalArea;
  final double usedArea;
  final double wasteArea;
  final double wastePercentage;

  const _WasteCard({
    required this.groupId,
    required this.totalArea,
    required this.usedArea,
    required this.wasteArea,
    required this.wastePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = wastePercentage < 3
        ? const Color(0xFF10B981)
        : wastePercentage < 5
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);
    final badgeBg = wastePercentage < 3
        ? const Color(0xFFDCFCE7)
        : wastePercentage < 5
        ? const Color(0xFFFEF3C7)
        : const Color(0xFFFEE2E2);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مجموعة $groupId',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${wastePercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: badgeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _WasteRow(
            label: 'المساحة الكلية:',
            value: '${(totalArea / 10000).toStringAsFixed(2)} م²',
          ),
          const SizedBox(height: 4),
          _WasteRow(
            label: 'المساحة المستخدمة:',
            value: '${(usedArea / 10000).toStringAsFixed(2)} م²',
          ),
          const Divider(height: 16),
          _WasteRow(
            label: 'الهادر:',
            value: '${(wasteArea / 10000).toStringAsFixed(2)} م²',
            isHighlight: true,
          ),
        ],
      ),
    );
  }
}

class _WasteRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isHighlight;

  const _WasteRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isHighlight
                ? const Color(0xFFC2410C)
                : const Color(0xFF4B5563),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlight
                ? const Color(0xFF9A3412)
                : const Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
