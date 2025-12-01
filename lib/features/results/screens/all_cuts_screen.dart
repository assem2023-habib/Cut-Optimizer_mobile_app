import 'package:flutter/material.dart';
import '../../../models/group_carpet.dart';
import '../../../utils/results_calculator.dart';

class AllCutsScreen extends StatelessWidget {
  final List<GroupCarpet> groups;

  const AllCutsScreen({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('جميع القصات'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CutDetailItem(group: groups[index], index: index),
          );
        },
      ),
    );
  }
}

class _CutDetailItem extends StatelessWidget {
  final GroupCarpet group;
  final int index;

  const _CutDetailItem({required this.group, required this.index});

  @override
  Widget build(BuildContext context) {
    final color = ResultsCalculator.getColorForGroup(index);
    final piecesCount = ResultsCalculator.getPiecesCountInGroup(group);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Color(int.parse('0xFF${color.substring(1)}')),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Group ID and Color
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(int.parse('0xFF${color.substring(1)}')),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${group.groupId}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'مجموعة ${group.groupId}',
                style: const TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$piecesCount قطعة',
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),

          // Dimensions
          Row(
            children: [
              Expanded(
                child: _InfoColumn(
                  label: 'العرض الكلي',
                  value: '${group.totalWidth} سم',
                  icon: Icons.width_full,
                ),
              ),
              Expanded(
                child: _InfoColumn(
                  label: 'أقصى طول',
                  value: '${group.maxHeight} سم',
                  icon: Icons.height,
                ),
              ),
              Expanded(
                child: _InfoColumn(
                  label: 'أقصى طول مرجعي',
                  value: '${group.maxLengthRef} سم',
                  icon: Icons.straighten,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'تفاصيل القطع:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),

          // List of items in the group
          ...group.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 8),
                  Text(
                    'C-${item.carpetId.toString().padLeft(3, '0')}: ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  Text(
                    '${item.width}×${item.height} سم',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  if (item.qtyUsed > 1)
                    Text(
                      ' (×${item.qtyUsed})',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B5563),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoColumn({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF9CA3AF)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
