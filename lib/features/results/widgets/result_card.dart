import 'dart:ui';
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String groupId;
  final double width;
  final double height;
  final int quantity;
  final String status; // "Completed" or "Pending"

  const ResultCard({
    super.key,
    required this.groupId,
    required this.width,
    required this.height,
    required this.quantity,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Determine status badge colors
    final bool isCompleted = status.toLowerCase() == 'completed';
    final Color badgeBgColor = isCompleted
        ? const Color(0xFFE6FFEE)
        : const Color(0xFFFFF3E0);
    final Color badgeTextColor = isCompleted
        ? const Color(0xFF28A745)
        : const Color(0xFFFFA000);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4EEB).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row for Group ID and Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group ID
                    Expanded(
                      child: Text(
                        groupId,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Dimensions and Quantity
                Wrap(
                  spacing: 20,
                  runSpacing: 8,
                  children: [
                    _buildDimensionItem('W:', width.toStringAsFixed(1)),
                    _buildDimensionItem('H:', height.toStringAsFixed(1)),
                    _buildDimensionItem('Q:', quantity.toString()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDimensionItem(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}
