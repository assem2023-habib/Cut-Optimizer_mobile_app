import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../shared/layout/main_layout.dart';
import '../../../core/constants/app_routes.dart';
import '../../processing/screens/processing_options_screen.dart';

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
            _UploadArea(file: _file, onTap: _pickFile, onClear: _clearFile),

            const SizedBox(height: 16),

            // 3. رسالة الخطأ
            if (_error != null) _ErrorMessage(error: _error!),

            if (_error != null) const SizedBox(height: 16),

            // 4. متطلبات الملف
            const _FileRequirements(),

            const SizedBox(height: 24),

            // 5. زر المتابعة
            _ContinueButton(enabled: _file != null, onPressed: _continue),

            const SizedBox(height: 16),

            // 6. Info Box
            const _InfoBox(),
          ],
        ),
      ),
    );
  }
}

/// منطقة الرفع
class _UploadArea extends StatelessWidget {
  final PlatformFile? file;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _UploadArea({this.file, required this.onTap, required this.onClear});

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
            ? _FileUploaded(file: file!, onClear: onClear)
            : const _EmptyState(),
      ),
    );
  }
}

/// الحالة الفارغة
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // أيقونة Upload في دائرة
        Container(
          padding: const EdgeInsets.all(16), // p-4
          decoration: const BoxDecoration(
            color: Color(0xFFDBEAFE), // blue-100
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.upload_file,
            size: 32, // w-8 h-8
            color: Color(0xFF2563EB), // blue-600
          ),
        ),

        const SizedBox(height: 16),

        const Text(
          'اضغط لاختيار ملف',
          style: TextStyle(
            color: Color(0xFF374151), // gray-700
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        const Text(
          'Excel (.xlsx, .xls)',
          style: TextStyle(
            color: Color(0xFF6B7280), // gray-500
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

/// حالة تم الرفع
class _FileUploaded extends StatelessWidget {
  final PlatformFile file;
  final VoidCallback onClear;

  const _FileUploaded({required this.file, required this.onClear});

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

/// رسالة الخطأ
class _ErrorMessage extends StatelessWidget {
  final String error;

  const _ErrorMessage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), // red-50
        border: Border.all(color: const Color(0xFFFECACA)), // red-200
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2), // mt-0.5
            child: Icon(
              Icons.error_outline,
              size: 20,
              color: Color(0xFFDC2626), // red-600
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFB91C1C), // red-700
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// متطلبات الملف
class _FileRequirements extends StatelessWidget {
  const _FileRequirements();

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
          // العنوان
          const Row(
            children: [
              Icon(
                Icons.table_chart,
                size: 20,
                color: Color(0xFF2563EB), // blue-600
              ),
              SizedBox(width: 8),
              Text(
                'متطلبات الملف',
                style: TextStyle(
                  color: Color(0xFF1F2937), // gray-800
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // المتطلبات
          ..._requirements.map((req) => _RequirementItem(text: req)),
        ],
      ),
    );
  }
}

const _requirements = [
  'الملف بدون ترويسة في الصف الأول',
  'العمود A: رقم طلب العميل',
  'العمود B: العرض (Width)',
  'العمود C: الطول (Height)',
  'العمود D: الكمية (Qty)',
  'العمود E: نوع القطعة (A للأزواج)',
  'العمود F: نوع النسيج (B للتدوير)',
  'العمود G: كود التحضير (A/B/C/D)',
];

/// عنصر متطلب واحد
class _RequirementItem extends StatelessWidget {
  final String text;

  const _RequirementItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // النقطة
          Container(
            width: 6, // w-1.5
            height: 6, // h-1.5
            margin: const EdgeInsets.only(top: 8), // mt-2
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB), // blue-600
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 8),

          // النص
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF374151), // gray-700
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// زر المتابعة
class _ContinueButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const _ContinueButton({required this.enabled, required this.onPressed});

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFD1D5DB), // gray-300
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'المتابعة',
              style: TextStyle(
                color: Color(0xFF6B7280), // gray-500
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.check_circle, color: Color(0xFF6B7280), size: 20),
          ],
        ),
      );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'المتابعة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.check_circle, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Info Box
class _InfoBox extends StatelessWidget {
  const _InfoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // blue-50
        border: Border.all(color: const Color(0xFFBFDBFE)), // blue-200
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(
            color: Color(0xFF1E40AF), // blue-800
            fontSize: 14,
            height: 1.625,
          ),
          children: [
            TextSpan(text: '💡 '),
            TextSpan(
              text: 'نصيحة: ',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text:
                  'يمكنك تحميل ملف نموذجي من قسم الإعدادات لمعرفة التنسيق الصحيح.',
            ),
          ],
        ),
      ),
    );
  }
}
