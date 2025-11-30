import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

/// Download Excel Button with Share, Save, and Open options
/// يوفر خيارات الحفظ، المشاركة، وفتح الملف
class DownloadExcelButton extends StatelessWidget {
  final String filePath;

  const DownloadExcelButton({super.key, required this.filePath});

  /// فتح الملف مباشرة
  Future<void> _openFile(BuildContext context) async {
    try {
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('لا يمكن فتح الملف: ${result.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في فتح الملف: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// مشاركة الملف عبر تطبيقات أخرى
  Future<void> _shareFile(BuildContext context) async {
    try {
      final File file = File(filePath);
      if (!await file.exists()) {
        throw Exception("الملف غير موجود");
      }

      final xFile = XFile(filePath);
      await Share.shareXFiles([xFile], text: 'تقرير تحسين القص');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في المشاركة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// حفظ الملف في الجهاز
  Future<void> _saveFile(BuildContext context) async {
    try {
      final File original = File(filePath);
      if (!await original.exists()) {
        throw Exception("الملف الأصلي غير موجود");
      }

      // قراءة الملف كـ bytes لتمريرها لـ file_picker
      // هذا ضروري لتجنب خطأ "Bytes are required" على Android/iOS
      final Uint8List bytes = await original.readAsBytes();

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'حفظ التقرير',
        fileName: 'cut_optimizer_report.xlsx',
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        bytes: bytes, // الحل للمشكلة
      );

      if (outputFile != null) {
        // التحقق مما إذا كان يجب الكتابة يدوياً (لبعض المنصات)
        final File savedFile = File(outputFile);
        if (!await savedFile.exists()) {
          await savedFile.writeAsBytes(bytes);
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ الملف بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في الحفظ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الصف الأول: زر الحفظ (كبير)
        GestureDetector(
          onTap: () => _saveFile(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF16A34A), // Green
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
                  'حفظ في الجهاز',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.save_alt, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // الصف الثاني: زر فتح وزر مشاركة
        Row(
          children: [
            // زر فتح الملف
            Expanded(
              child: GestureDetector(
                onTap: () => _openFile(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'فتح',
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.open_in_new,
                        color: Color(0xFF374151),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // زر المشاركة
            Expanded(
              child: GestureDetector(
                onTap: () => _shareFile(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'مشاركة',
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.share_outlined,
                        color: Color(0xFF374151),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
