import 'package:flutter/material.dart';
import '../../../core/enums.dart';
import '../../execution/screens/execution_screen.dart';
import '../widgets/processing_config_section.dart';
import '../../../models/config.dart';
import '../../../services/background_service.dart';

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

    // Navigate directly to ExecutionScreen
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BackgroundService.getBackgroundDecoration(
          widget.config.backgroundImage,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The Processing Configuration Section (Glass Card)
                    ProcessingConfigSection(
                      config: widget.config,
                      onChanged: _onConfigChanged,
                    ),

                    const SizedBox(height: 32),

                    // Next Button
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _navigateToNextScreen,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4EEB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFF6B4EEB).withOpacity(0.4),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Start Processing",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.play_arrow_rounded, size: 24),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
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
