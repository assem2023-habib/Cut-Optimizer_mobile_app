import 'package:flutter/material.dart';
import '../../../core/enums.dart';

class SortingOptionTile extends StatelessWidget {
  final SortType value;
  final SortType groupValue;
  final String label;
  final ValueChanged<SortType?> onChanged;

  const SortingOptionTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.blue.shade700, width: 1)
              : null,
        ),
        child: Row(
          children: [
            Radio<SortType>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: Colors.blue.shade700,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
