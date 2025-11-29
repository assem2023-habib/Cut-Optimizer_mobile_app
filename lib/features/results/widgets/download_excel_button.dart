import 'package:flutter/material.dart';

/// Download Excel Button
class DownloadExcelButton extends StatelessWidget {
  final String filePath;

  const DownloadExcelButton({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Open/share file
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('ملف Excel: $filePath')));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF16A34A),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF16A34A).withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'تحميل التقرير (Excel)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.download, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
