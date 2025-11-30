import 'package:flutter/material.dart';
import '../../../models/group_carpet.dart';
import '../../../models/carpet_used.dart';
import '../../../utils/results_calculator.dart';

/// Tab 1: القصات
class CutsTab extends StatelessWidget {
  final List<GroupCarpet> groups;

  const CutsTab({super.key, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...groups.asMap().entries.map((entry) {
          final index = entry.key;
          final group = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ExpandableCutCard(
              group: group,
              color: ResultsCalculator.getColorForGroup(index),
            ),
          );
        }).toList(),
        // مسافة إضافية لتجنب تداخل مع BottomNavBar
        const SizedBox(height: 80),
      ],
    );
  }
}

class _ExpandableCutCard extends StatefulWidget {
  final GroupCarpet group;
  final String color;

  const _ExpandableCutCard({required this.group, required this.color});

  @override
  State<_ExpandableCutCard> createState() => _ExpandableCutCardState();
}

class _ExpandableCutCardState extends State<_ExpandableCutCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse('0xFF${widget.color.substring(1)}'),
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.group.groupId}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مجموعة ${widget.group.groupId}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${widget.group.totalWidth} × ${widget.group.maxHeight} سم',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '× ${widget.group.repetitions}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFF9CA3AF),
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
                color: Color(0xFFF9FAFB),
              ),
              child: Column(
                children: widget.group.items
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _PieceItem(
                          orderId:
                              'C-${item.carpetId.toString().padLeft(3, '0')}',
                          width: item.width,
                          height: item.height,
                          quantity: item.qtyUsed,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _PieceItem extends StatelessWidget {
  final String orderId;
  final int width;
  final int height;
  final int quantity;

  const _PieceItem({
    required this.orderId,
    required this.width,
    required this.height,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '× $quantity',
                  style: const TextStyle(
                    color: Color(0xFF1D4ED8),
                    fontSize: 12,
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
                  'العرض: $width سم',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'الطول: $height سم',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
