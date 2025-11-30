import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

/// حالة تم رفع الملف
class FileUploaded extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback onClear;

  const FileUploaded({super.key, required this.file, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final fileSizeKB = (file.size / 1024).toStringAsFixed(2);

    return Column(
      children: [
        // أيقونة Success
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFDCFCE7), // green-100
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            size: 32,
            color: Color(0xFF16A34A), // green-600
          ),
        ),

        const SizedBox(height: 16),

        // اسم الملف
        Text(
          file.name,
          style: const TextStyle(
            color: Color(0xFF15803D), // green-700
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // حجم الملف
        Text(
          '$fileSizeKB كيلوبايت',
          style: const TextStyle(
            color: Color(0xFF16A34A), // green-600
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 12),

        // زر اختر ملف آخر
        GestureDetector(
          onTap: onClear,
          child: const Text(
            'اختر ملف آخر',
            style: TextStyle(
              color: Color(0xFF4B5563), // gray-600
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
