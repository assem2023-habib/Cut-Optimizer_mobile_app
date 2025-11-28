import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import '../widgets/file_import_section.dart';
import '../widgets/file_preview_section.dart';
import '../../set_constraints/screens/set_constraints_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../../models/config.dart';
import '../../../services/config_service.dart';
import '../../../services/background_service.dart';

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
  Config? _config;
  final ConfigService _configService = ConfigService();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _configService.loadConfig();
    setState(() {
      _config = config;
    });
  }

  Future<void> _openSettings() async {
    if (_config == null) return;

    final updatedConfig = await Navigator.of(context).push<Config>(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(config: _config!),
        fullscreenDialog: true,
      ),
    );

    if (updatedConfig != null) {
      setState(() {
        _config = updatedConfig;
      });
    }
  }

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
      // Navigate directly to Processing Configuration (SetConstraintsScreen)
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SetConstraintsScreen(
            filePath: _selectedFilePath!,
            config: _config ?? Config.defaultConfig(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundDecoration = _config != null
        ? BackgroundService.getBackgroundDecoration(_config!.backgroundImage)
        : null;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        flexibleSpace: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _openSettings,
                  icon: Icon(Icons.settings, size: 28),
                  color: Color(0xFF6B4EEB),
                  tooltip: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: SafeArea(
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
      ),
    );
  }
}
