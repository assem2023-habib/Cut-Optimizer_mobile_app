import 'package:flutter/material.dart';
import '../../../core/enums.dart';
import '../../execution/screens/execution_screen.dart';
import '../widgets/processing_config_section.dart';
import '../../../models/config.dart';

class SetConstraintsScreen extends StatefulWidget {
  final String filePath;
  final Config config;

  const SetConstraintsScreen({
    super.key,
    required this.filePath,
    required this.config,
  });

  @override
  State<SetConstraintsScreen> createState() => _SetConstraintsScreenState();
}

class _SetConstraintsScreenState extends State<SetConstraintsScreen> {
  // State to hold values from ProcessingConfigSection
  MachineSize? _selectedMachine;
  String _tolerance = "5";
  SortType _sortType = SortType.sortByHeight;
  GroupingMode _groupingMode = GroupingMode.noMainRepeat;

  void _onConfigChanged(
    MachineSize? machine,
    String tolerance,
    SortType sortType,
    GroupingMode groupingMode,
  ) {
    setState(() {
      _selectedMachine = machine;
      _tolerance = tolerance;
      _sortType = sortType;
      _groupingMode = groupingMode;
    });
  }

  void _navigateToNextScreen() {
    final minWidth = _selectedMachine?.minWidth ?? 50;
    final maxWidth = _selectedMachine?.maxWidth ?? 400;
    final tolerance = int.tryParse(_tolerance) ?? 5;

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

    // Navigate directly to ExecutionScreen, skipping SortingOptionsScreen and GroupingModeScreen
    // as their configuration is now handled here.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExecutionScreen(
          filePath: widget.filePath,
          minWidth: minWidth,
          maxWidth: maxWidth,
          tolerance: tolerance,
          sortType: _sortType,
          groupingMode: _groupingMode,
          config: widget.config,
          optimizeResults: true, // Default
          generateReport: false, // Default
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
                        const SizedBox(height: 20),
                        ProcessingConfigSection(
                          config: widget.config,
                          onChanged: _onConfigChanged,
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
