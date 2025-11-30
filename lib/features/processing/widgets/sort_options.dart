import 'package:flutter/material.dart';

/// Sort Options - خيارات الترتيب
class SortOptions extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const SortOptions({
    super.key,
    required this.selected,
    required this.onSelect,
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
            'ترتيب القطع',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          _SortOption(
            label: 'حسب الطول',
            value: 'length',
            isSelected: selected == 'length',
            onTap: () => onSelect('length'),
          ),

          const SizedBox(height: 12),

          _SortOption(
            label: 'حسب العرض',
            value: 'width',
            isSelected: selected == 'width',
            onTap: () => onSelect('width'),
          ),

          const SizedBox(height: 12),

          _SortOption(
            label: 'حسب الكمية',
            value: 'quantity',
            isSelected: selected == 'quantity',
            onTap: () => onSelect('quantity'),
          ),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOption({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFEFF6FF) // blue-50
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF2563EB) // blue-600
                : const Color(0xFFE5E7EB), // gray-200
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF1D4ED8) // blue-700
                    : const Color(0xFF4B5563), // gray-600
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
