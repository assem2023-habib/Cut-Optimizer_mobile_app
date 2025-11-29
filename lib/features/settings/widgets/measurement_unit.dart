import 'package:flutter/material.dart';
import '../../../models/config.dart';

/// القسم 2: وحدة القياس
class MeasurementUnitWidget extends StatelessWidget {
  final MeasurementUnit selectedUnit;
  final Function(MeasurementUnit) onUnitChanged;

  const MeasurementUnitWidget({
    super.key,
    required this.selectedUnit,
    required this.onUnitChanged,
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
            'وحدة القياس',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: UnitButton(
                  label: 'سنتيمتر (cm)',
                  isSelected: selectedUnit == MeasurementUnit.cm,
                  onTap: () => onUnitChanged(MeasurementUnit.cm),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: UnitButton(
                  label: 'متر (m)',
                  isSelected: selectedUnit == MeasurementUnit.m,
                  onTap: () => onUnitChanged(MeasurementUnit.m),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// زر وحدة القياس
class UnitButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const UnitButton({
    super.key,
    required this.label,
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
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF1D4ED8) // blue-700
                : const Color(0xFF4B5563), // gray-600
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
