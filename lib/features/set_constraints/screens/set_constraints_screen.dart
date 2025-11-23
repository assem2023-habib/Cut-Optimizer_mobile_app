import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../../sorting_options/screens/sorting_options_screen.dart';

class SetConstraintsScreen extends StatefulWidget {
  final String filePath;

  const SetConstraintsScreen({super.key, required this.filePath});

  @override
  State<SetConstraintsScreen> createState() => _SetConstraintsScreenState();
}

class _SetConstraintsScreenState extends State<SetConstraintsScreen> {
  final TextEditingController _maxWidthController = TextEditingController(
    text: "400",
  );
  final TextEditingController _minWidthController = TextEditingController(
    text: "50",
  );
  final TextEditingController _toleranceController = TextEditingController(
    text: "5",
  );

  @override
  void dispose() {
    _maxWidthController.dispose();
    _minWidthController.dispose();
    _toleranceController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    final maxWidth = int.tryParse(_maxWidthController.text) ?? 400;
    final minWidth = int.tryParse(_minWidthController.text) ?? 50;
    final tolerance = int.tryParse(_toleranceController.text) ?? 5;

    // Validate constraints
    if (minWidth >= maxWidth) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Minimum width must be less than maximum width"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SortingOptionsScreen(
          filePath: widget.filePath,
          minWidth: minWidth,
          maxWidth: maxWidth,
          tolerance: tolerance,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue.shade900),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SET CONSTRAINTS",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          label: "Max Width",
                          initialValue: "400",
                          suffixText: "cm",
                          controller: _maxWidthController,
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: "Min Width",
                          initialValue: "50",
                          suffixText: "cm",
                          controller: _minWidthController,
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: "Tolerance",
                          initialValue: "5",
                          suffixText: "cm",
                          controller: _toleranceController,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _navigateToNextScreen,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF0D47A1,
                              ), // Corporate Blue
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
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
