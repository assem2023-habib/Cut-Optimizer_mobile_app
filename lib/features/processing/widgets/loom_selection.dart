import 'package:flutter/material.dart';
import '../../../models/config.dart';

/// Loom Selection - اختيار النول
class LoomSelection extends StatelessWidget {
  final List<MachineSize> looms;
  final int? selectedIndex;
  final Function(int) onSelect;

  const LoomSelection({
    super.key,
    required this.looms,
    required this.selectedIndex,
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
            'اختر النول',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          ...looms.asMap().entries.map((entry) {
            final index = entry.key;
            final loom = entry.value;
            final isSelected = selectedIndex == index;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => onSelect(index),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
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
                      // Radio Button
                      Container(
                        width: 24,
                        height: 24,
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
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            : null,
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loom.name,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF1E40AF) // blue-800
                                    : const Color(0xFF1F2937), // gray-800
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${loom.minWidth} - ${loom.maxWidth} سم | سماحية: ${loom.tolerance} سم',
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFF2563EB) // blue-600
                                    : const Color(0xFF6B7280), // gray-500
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
