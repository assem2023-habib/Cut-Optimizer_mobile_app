import 'package:flutter/material.dart';

/// Area Info
class AreaInfo extends StatelessWidget {
  final double totalArea;
  final double usedArea;
  final double wasteArea;

  const AreaInfo({
    super.key,
    required this.totalArea,
    required this.usedArea,
    required this.wasteArea,
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
            'معلومات المساحة',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _AreaItem(
            label: 'المساحة الكلية',
            value: '${totalArea.toStringAsFixed(2)} م²',
            highlight: false,
          ),
          const SizedBox(height: 8),
          _AreaItem(
            label: 'المساحة المستخدمة',
            value: '${usedArea.toStringAsFixed(2)} م²',
            highlight: false,
          ),
          const SizedBox(height: 8),
          _AreaItem(
            label: 'الهادر',
            value: '${wasteArea.toStringAsFixed(2)} م²',
            highlight: true,
          ),
        ],
      ),
    );
  }
}

class _AreaItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _AreaItem({
    required this.label,
    required this.value,
    required this.highlight,
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
                  : const Color(0xFF374151),
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
