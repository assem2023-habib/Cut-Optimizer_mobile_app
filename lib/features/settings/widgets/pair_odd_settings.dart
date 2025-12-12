import 'package:flutter/material.dart';
import '../../../models/config.dart';

/// Widget for pair/odd settings
class PairOddSettings extends StatefulWidget {
  final PairOddMode selectedMode;
  final Function(PairOddMode) onModeChanged;

  const PairOddSettings({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  State<PairOddSettings> createState() => _PairOddSettingsState();
}

class _PairOddSettingsState extends State<PairOddSettings> {
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
            'إعدادات زوجي/فردي',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'اختر كيفية التعامل مع الكميات في ملف الإدخال',
            style: TextStyle(
              color: Color(0xFF4B5563),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          
          // Radio buttons for pair/odd modes
          Column(
            children: [
              _buildRadioOption(
                title: 'معطل',
                description: 'لا يتم تطبيق أي تعديل على الكميات',
                value: PairOddMode.disabled,
              ),
              const SizedBox(height: 12),
              _buildRadioOption(
                title: 'زوجي (Pair)',
                description: 'تقسيم الكميات على 2 (للأزواج)',
                value: PairOddMode.pair,
              ),
              const SizedBox(height: 12),
              _buildRadioOption(
                title: 'فردي (Odd)',
                description: 'الاحتفاظ بالكميات كما هي (للأفراد)',
                value: PairOddMode.odd,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption({
    required String title,
    required String description,
    required PairOddMode value,
  }) {
    return InkWell(
      onTap: () => widget.onModeChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.selectedMode == value
                ? const Color(0xFF2563EB)
                : const Color(0xFFE5E7EB),
            width: widget.selectedMode == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: widget.selectedMode == value
              ? const Color(0xFFEFF6FF)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<PairOddMode>(
              value: value,
              groupValue: widget.selectedMode,
              onChanged: (PairOddMode? newValue) {
                if (newValue != null) {
                  widget.onModeChanged(newValue);
                }
              },
              activeColor: const Color(0xFF2563EB),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: widget.selectedMode == value
                          ? const Color(0xFF2563EB)
                          : const Color(0xFF1F2937),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
