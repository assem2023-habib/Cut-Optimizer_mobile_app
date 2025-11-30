import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'empty_state.dart';
import 'file_uploaded.dart';

/// منطقة رفع الملف
class UploadArea extends StatelessWidget {
  final PlatformFile? file;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const UploadArea({
    super.key,
    this.file,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasFile = file != null;

    return InkWell(
      onTap: hasFile ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(32), // p-8
        decoration: BoxDecoration(
          color: hasFile
              ? const Color(0xFFF0FDF4) // green-50
              : Colors.white,
          border: Border.all(
            color: hasFile
                ? const Color(0xFF4ADE80) // green-400
                : const Color(0xFFD1D5DB), // gray-300
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16), // rounded-2xl
        ),
        child: hasFile
            ? FileUploaded(file: file!, onClear: onClear)
            : const EmptyState(),
      ),
    );
  }
}
