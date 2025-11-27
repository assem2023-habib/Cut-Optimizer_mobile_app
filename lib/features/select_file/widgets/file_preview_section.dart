import 'package:flutter/material.dart';

class FilePreviewSection extends StatelessWidget {
  final String? fileName;
  final int? rows;
  final int? columns;
  final bool isLoading;

  const FilePreviewSection({
    super.key,
    this.fileName,
    this.rows,
    this.columns,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(Icons.visibility, color: Color(0xFF6B4EEB), size: 20),
            SizedBox(width: 8),
            Text(
              'File Preview',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),

        // File Details or Loading
        if (isLoading) ...[
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF6B4EEB),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Reading file...',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ),
          ),
        ] else if (fileName != null) ...[
          _buildDetailRow('File Name:', fileName!),
          SizedBox(height: 16),
          _buildDetailRow('Rows:', rows?.toString() ?? '0'),
          SizedBox(height: 16),
          _buildDetailRow('Columns:', columns?.toString() ?? '0'),
        ] else ...[
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'No file selected',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(fontSize: 15, color: Color(0xFF333333)),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}
