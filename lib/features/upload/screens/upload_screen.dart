import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../shared/layout/main_layout.dart';
import '../../processing/screens/processing_options_screen.dart';
import '../widgets/upload_area.dart';
import '../widgets/error_message.dart';
import '../widgets/file_requirements.dart';
import '../widgets/continue_button.dart';
import '../widgets/info_box.dart';

/// شاشة رفع الملف (Upload Screen) - التصميم الجديد
/// 6 أقسام: العنوان + منطقة الرفع + رسالة خطأ + المتطلبات + زر المتابعة + نصيحة
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  PlatformFile? _file;
  String? _error;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        setState(() {
          _file = result.files.first;
          _error = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ أثناء اختيار الملف';
      });
    }
  }

  void _clearFile() {
    setState(() {
      _file = null;
      _error = null;
    });
  }

  void _continue() {
    if (_file == null) {
      setState(() {
        _error = 'يرجى اختيار ملف Excel (.xlsx أو .xls)';
      });
      return;
    }

    // Navigate to processing options with file details
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProcessingOptionsScreen(
          fileName: _file!.name,
          fileSize: _file!.size,
          filePath: _file!.path,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentPage: 'upload',
      showBottomNav: true,
      hasProcessedData: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. العنوان والوصف
            const Text(
              'رفع ملف Excel',
              style: TextStyle(
                color: Color(0xFF1F2937), // gray-800
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'قم برفع ملف Excel يحتوي على طلبات العملاء للبدء في المعالجة',
              style: TextStyle(
                color: Color(0xFF4B5563), // gray-600
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

            // 2. منطقة الرفع
            UploadArea(file: _file, onTap: _pickFile, onClear: _clearFile),

            const SizedBox(height: 16),

            // 3. رسالة الخطأ
            if (_error != null) ErrorMessage(error: _error!),

            if (_error != null) const SizedBox(height: 16),

            // 4. متطلبات الملف
            const FileRequirements(),

            const SizedBox(height: 24),

            // 5. زر المتابعة
            ContinueButton(enabled: _file != null, onPressed: _continue),

            const SizedBox(height: 16),

            // 6. Info Box
            const InfoBox(),

            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
