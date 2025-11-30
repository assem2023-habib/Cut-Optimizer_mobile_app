import 'package:flutter/material.dart';

/// Repeat Main Option - أولوية التكرار
class RepeatMainOption extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const RepeatMainOption({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'أولوية التكرار',
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
              child: _RepeatCard(
                type: 'repeat',
                isSelected: selected == 'repeat',
                onTap: () => onSelect('repeat'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RepeatCard(
                type: 'no-repeat',
                isSelected: selected == 'no-repeat',
                onTap: () => onSelect('no-repeat'),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // صندوق التوضيح
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected == 'repeat'
                ? const Color(0xFFF0FDF4) // green-50
                : const Color(0xFFFFF7ED), // orange-50
            border: Border.all(
              color: selected == 'repeat'
                  ? const Color(0xFFBBF7D0) // green-200
                  : const Color(0xFFFED7AA), // orange-200
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Text(
                selected == 'repeat' ? '📋' : '🚫',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  selected == 'repeat'
                      ? 'سيتم تكرار القطع الرئيسية أولاً لتحقيق أفضل كفاءة'
                      : 'سيتم الدمج بدون تكرار القطع الرئيسية',
                  style: TextStyle(
                    color: selected == 'repeat'
                        ? const Color(0xFF166534) // green-800
                        : const Color(0xFF9A3412), // orange-800
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RepeatCard extends StatelessWidget {
  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  const _RepeatCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRepeat = type == 'repeat';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isRepeat
                    ? const Color(0xFFF0FDF4) // green-50
                    : const Color(0xFFFFF7ED)) // orange-50
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? (isRepeat
                      ? const Color(0xFF16A34A) // green-600
                      : const Color(0xFFEA580C)) // orange-600
                : const Color(0xFFE5E7EB), // gray-200
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // دائرة الأيقونة
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isRepeat
                    ? const Color(0xFFDCFCE7) // green-100
                    : const Color(0xFFFFEDD5), // orange-100
                shape: BoxShape.circle,
              ),
              child: Icon(
                isRepeat ? Icons.repeat : Icons.block,
                color: isRepeat
                    ? const Color(0xFF16A34A) // green-600
                    : const Color(0xFFEA580C), // orange-600
                size: 24,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              isRepeat ? 'تكرار' : 'بدون تكرار',
              style: TextStyle(
                color: isRepeat
                    ? const Color(0xFF166534) // green-800
                    : const Color(0xFF9A3412), // orange-800
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              isRepeat ? 'كفاءة أعلى' : 'تنوع أكبر',
              style: TextStyle(
                color: isRepeat
                    ? const Color(0xFF16A34A) // green-600
                    : const Color(0xFFEA580C), // orange-600
                fontSize: 12,
              ),
            ),

            const SizedBox(height: 8),

            // علامة التحديد
            if (isSelected)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isRepeat
                      ? const Color(0xFF16A34A)
                      : const Color(0xFFEA580C),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
