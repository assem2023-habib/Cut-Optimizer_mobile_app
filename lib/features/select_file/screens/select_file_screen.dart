import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/upload_box.dart';
import '../../set_constraints/screens/set_constraints_screen.dart';

class SelectFileScreen extends StatefulWidget {
  const SelectFileScreen({super.key});

  @override
  State<SelectFileScreen> createState() => _SelectFileScreenState();
}

class _SelectFileScreenState extends State<SelectFileScreen> {
  String? _selectedFilePath;

  void _handleFileSelection(String path) {
    setState(() {
      _selectedFilePath = path;
    });
    // ignore: avoid_print
    print("File selected: $path");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("File selected: ${path.split('/').last}"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _pickFileManually() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null && result.files.single.path != null) {
      _handleFileSelection(result.files.single.path!);
    }
  }

  void _navigateToNextScreen() {
    if (_selectedFilePath != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SetConstraintsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SELECT EXCEL FILE",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 40),
                UploadBox(onFileSelected: _handleFileSelection),
                const SizedBox(height: 40),
                TextButton.icon(
                  onPressed: _pickFileManually,
                  icon: Icon(
                    CupertinoIcons.folder,
                    size: 20,
                    color: Colors.blue.shade700,
                  ),
                  label: Text(
                    "or select from device",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                // Show Continue button only when file is selected
                AnimatedOpacity(
                  opacity: _selectedFilePath != null ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedSlide(
                    offset: _selectedFilePath != null
                        ? Offset.zero
                        : const Offset(0, 0.3),
                    duration: const Duration(milliseconds: 300),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _selectedFilePath != null
                            ? _navigateToNextScreen
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Next >",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
