import 'package:flutter/material.dart';

/// القسم 4: أزرار الإجراءات
class ActionButtons extends StatelessWidget {
  final bool isSaved;
  final VoidCallback onReset;
  final VoidCallback onSave;

  const ActionButtons({
    super.key,
    required this.isSaved,
    required this.onReset,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // إعادة تعيين
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text('إعادة تعيين'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE5E7EB), // gray-200
              foregroundColor: const Color(0xFF374151), // gray-700
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // حفظ - استخدام Container للتدرج
        Expanded(
          child: InkWell(
            onTap: onSave,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSaved ? const Color(0xFF16A34A) : null,
                gradient: isSaved
                    ? null
                    : const LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color(0xFF2563EB), // blue-600
                          Color(0xFF1D4ED8), // blue-700
                        ],
                      ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSaved ? Icons.check : Icons.save,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isSaved ? 'تم الحفظ' : 'حفظ الإعدادات',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
