import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dashed_border_painter.dart';

class UploadBox extends StatelessWidget {
  final Function(String) onFileSelected;

  const UploadBox({super.key, required this.onFileSelected});

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null && result.files.single.path != null) {
      onFileSelected(result.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: Colors.blue.shade300,
          strokeWidth: 2.0,
          dashPattern: 8.0,
          radius: 16.0,
        ),
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Upload Excel File",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
