import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import '../widgets/file_import_section.dart';
import '../widgets/file_preview_section.dart';
import '../../grouping_mode/screens/grouping_mode_screen.dart';

class SelectFileScreen extends StatefulWidget {
  const SelectFileScreen({super.key});

  @override
  State<SelectFileScreen> createState() => _SelectFileScreenState();
}

class _SelectFileScreenState extends State<SelectFileScreen> {
  String? _selectedFilePath;
  String? _fileName;
  int? _rows;
  int? _columns;
  bool _isLoading = false;

  Future<void> _handleFileSelection(String filePath, PlatformFile file) async {
    setState(() {
      _isLoading = true;
      _selectedFilePath = filePath;
      _fileName = file.name;
    });

    try {
      // Read Excel file to get actual row/column count
      // Use bytes from PlatformFile for web compatibility
      late List<int> bytes;

      if (file.bytes != null) {
        // Web platform - use bytes directly
        bytes = file.bytes!;
      } else {
        // Mobile/Desktop platform - read from file path
        bytes = File(filePath).readAsBytesSync();
      }

      var excel = Excel.decodeBytes(bytes);

      // Get the first sheet
      if (excel.tables.isNotEmpty) {
        var table = excel.tables[excel.tables.keys.first];
        if (table != null) {
          setState(() {
            _rows = table.maxRows;
            _columns = table.maxColumns;
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _rows = 0;
          _columns = 0;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _rows = 0;
        _columns = 0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error reading Excel file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToNextScreen() {
    if (_selectedFilePath != null) {
      // Navigate directly to Processing Configuration
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GroupingModeScreen(
            filePath: _selectedFilePath!,
            minWidth: 50, // Default values
            maxWidth: 400,
            tolerance: 5,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Container(
              constraints: BoxConstraints(maxWidth: 1200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.05),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(32),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Responsive layout
                      if (constraints.maxWidth > 600) {
                        // Desktop/Tablet: Side by side
                        return IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: FileImportSection(
                                  onFileSelected: _handleFileSelection,
                                ),
                              ),
                              SizedBox(width: 48),
                              Expanded(
                                child: FilePreviewSection(
                                  fileName: _fileName,
                                  rows: _rows,
                                  columns: _columns,
                                  isLoading: _isLoading,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Mobile: Stacked vertically
                        return Column(
                          children: [
                            FileImportSection(
                              onFileSelected: _handleFileSelection,
                            ),
                            SizedBox(height: 32),
                            FilePreviewSection(
                              fileName: _fileName,
                              rows: _rows,
                              columns: _columns,
                              isLoading: _isLoading,
                            ),
                          ],
                        );
                      }
                    },
                  ),

                  // Next Button
                  if (_selectedFilePath != null && !_isLoading) ...[
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _navigateToNextScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6B4EEB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
