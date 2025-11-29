import 'package:flutter/material.dart';
import '../../../models/carpet.dart';
import '../../../models/group_carpet.dart';

/// Tab 3: التدقيق
class AuditTab extends StatelessWidget {
  final List<Carpet> originalGroups;
  final List<GroupCarpet> groups;
  final List<Carpet> remaining;

  const AuditTab({
    super.key,
    required this.originalGroups,
    required this.groups,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: originalGroups.map((original) {
        // Calculate produced quantity for this carpet ID
        int produced = 0;
        for (GroupCarpet group in groups) {
          for (var item in group.items) {
            if (item.carpetId == original.id) {
              produced += item.qtyUsed * group.repetitions;
            }
          }
        }

        // Add remaining quantity
        int rem = 0;
        for (var r in remaining) {
          if (r.id == original.id) {
            rem = r.remQty;
          }
        }

        // Total accounted for = produced + remaining
        int totalAccounted = produced + rem;
        bool isMatch = totalAccounted == original.qty;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _AuditCard(
            orderId: 'C-${original.id.toString().padLeft(3, '0')}',
            requested: original.qty,
            produced: produced,
            remaining: rem,
            isMatch: isMatch,
          ),
        );
      }).toList(),
    );
  }
}

class _AuditCard extends StatelessWidget {
  final String orderId;
  final int requested;
  final int produced;
  final int remaining;
  final bool isMatch;

  const _AuditCard({
    required this.orderId,
    required this.requested,
    required this.produced,
    required this.remaining,
    required this.isMatch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isMatch ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        border: Border.all(
          color: isMatch ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isMatch ? Icons.check_circle : Icons.warning,
            color: isMatch ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: TextStyle(
                    color: isMatch
                        ? const Color(0xFF166534)
                        : const Color(0xFF991B1B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'مطلوب: $requested',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'منتج: $produced',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'متبقي: $remaining',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
