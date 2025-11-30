import 'package:flutter/material.dart';

/// Success Card - بطاقة النجاح الخضراء
class SuccessCard extends StatelessWidget {
  final String fileName;
  final int fileSize;

  const SuccessCard({
    super.key,
    required this.fileName,
    required this.fileSize,
  });

  @override
  Widget build(BuildContext context) {
    final fileSizeKB = (fileSize / 1024).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF22C55E), // green-500
            Color(0xFF16A34A), // green-600
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // أيقونة زجاجية
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تم رفع الملف بنجاح',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$fileName ($fileSizeKB كيلوبايت)',
                  style: const TextStyle(
                    color: Color(0xFFDCFCE7), // green-100
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
