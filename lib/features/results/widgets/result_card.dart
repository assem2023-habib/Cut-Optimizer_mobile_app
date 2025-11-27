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
        ? Color(0xFFE6FFEE)
        : Color(0xFFFFF3E0);
    final Color badgeTextColor = isCompleted
        ? Color(0xFF28A745)
        : Color(0xFFFFA000);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              SizedBox(width: 8),

              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

          SizedBox(height: 12),

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
    );
  }

  Widget _buildDimensionItem(String label, String value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 13, color: Color(0xFF666666))),
        SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}
