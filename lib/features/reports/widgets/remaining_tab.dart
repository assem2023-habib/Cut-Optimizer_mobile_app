import 'package:flutter/material.dart';
import '../../../models/carpet.dart';

/// Tab 2: المتبقي
class RemainingTab extends StatelessWidget {
  final List<Carpet> remaining;

  const RemainingTab({super.key, required this.remaining});

  @override
  Widget build(BuildContext context) {
    if (remaining.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد قطع متبقية',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }
    return Column(
      children: remaining
          .map(
            (carpet) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _RemainingPieceCard(
                orderId: 'C-${carpet.id.toString().padLeft(3, '0')}',
                width: carpet.width,
                height: carpet.height,
                quantity: carpet.remQty,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _RemainingPieceCard extends StatelessWidget {
  final String orderId;
  final int width;
  final int height;
  final int quantity;

  const _RemainingPieceCard({
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
        color: const Color(0xFFFFF7ED),
        border: Border.all(color: const Color(0xFFFED7AA)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: const TextStyle(
                    color: Color(0xFF9A3412),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$width × $height سم',
                  style: const TextStyle(
                    color: Color(0xFFEA580C),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEDD5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '× $quantity',
              style: const TextStyle(
                color: Color(0xFFC2410C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
