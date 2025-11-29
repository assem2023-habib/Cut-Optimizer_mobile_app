import 'package:flutter/material.dart';
import '../../../models/group_carpet.dart';
import '../../../utils/results_calculator.dart';

/// Cuts Summary
class CutsSummary extends StatelessWidget {
  final List<GroupCarpet> groups;

  const CutsSummary({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    final displayGroups = groups.take(5).toList();

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
            'ملخص القصات',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...displayGroups.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CutItem(group: entry.value, index: entry.key),
            ),
          ),
          if (groups.length > 5)
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('عرض الكل'),
              ),
            ),
        ],
      ),
    );
  }
}

class _CutItem extends StatelessWidget {
  final GroupCarpet group;
  final int index;

  const _CutItem({required this.group, required this.index});

  @override
  Widget build(BuildContext context) {
    final color = ResultsCalculator.getColorForGroup(index);
    final piecesCount = ResultsCalculator.getPiecesCountInGroup(group);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(int.parse('0xFF${color.substring(1)}')),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF${color.substring(1)}')),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${group.groupId}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'مجموعة ${group.groupId}',
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'العرض الكلي: ${group.totalWidth} سم',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'الطول: ${group.maxHeight} سم',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 16),
          Text(
            '$piecesCount قطعة في هذه المجموعة',
            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}
