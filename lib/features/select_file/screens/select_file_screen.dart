import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/upload_box.dart';

class SelectFileScreen extends StatelessWidget {
  const SelectFileScreen({super.key});

  void _handleFileSelection(BuildContext context, String path) {
    // TODO: Navigate to next screen or process file
    // ignore: avoid_print
    print("File selected: $path");
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("File selected: $path")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
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
              UploadBox(
                onFileSelected: (path) => _handleFileSelection(context, path),
              ),
              const SizedBox(height: 40),
              TextButton.icon(
                onPressed: () {
                  // Same action as upload box for now
                  // Or maybe a different picker logic if needed
                },
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
            ],
          ),
        ),
      ),
    );
  }
}
