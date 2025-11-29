import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/enums.dart';
import '../../../services/data_service.dart';
import '../../../services/algorithm_service.dart';
import '../../../models/carpet.dart';
import '../../../models/group_carpet.dart';
import '../../results/screens/results_screen.dart';
import '../../../models/config.dart';
import '../../../services/background_service.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/execution_buttons.dart';

/// شاشة التنفيذ (Execution Screen)
/// تنفيذ عملية المعالجة والانتقال للنتائج
class ExecutionScreen extends StatefulWidget {
  final String filePath;
  final int minWidth;
  final int maxWidth;
  final int tolerance;
  final SortType sortType;
  final GroupingMode groupingMode;
  final bool optimizeResults;
  final bool generateReport;
  final Config config;

  const ExecutionScreen({
    super.key,
    required this.filePath,
    required this.minWidth,
    required this.maxWidth,
    required this.tolerance,
    required this.sortType,
    required this.groupingMode,
    this.optimizeResults = true,
    this.generateReport = false,
    required this.config,
  });

  @override
  State<ExecutionScreen> createState() => _ExecutionScreenState();
}

class _ExecutionScreenState extends State<ExecutionScreen> {
  double _progress = 0.0;
  bool _isExecuting = false;
  String _statusMessage = "Ready to execute";
  final DataService _dataService = DataService();
  final AlgorithmService _algorithmService = AlgorithmService();

  Future<void> _startExecution() async {
    setState(() {
      _isExecuting = true;
      _progress = 0.0;
      _statusMessage = "Starting execution...";
    });

    try {
      // Step 1: Read input Excel file (20% progress)
      setState(() {
        _progress = 0.1;
        _statusMessage = "Reading input file...";
      });

      List<Carpet> carpets = await _dataService.readInputExcel(widget.filePath);

      if (carpets.isEmpty) {
        throw Exception("No valid carpet data found in the file");
      }

      setState(() {
        _progress = 0.2;
        _statusMessage = "Loaded ${carpets.length} carpets";
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // Step 2: Execute algorithm (20% - 70% progress)
      setState(() {
        _progress = 0.3;
        _statusMessage = "Building groups...";
      });

      List<Carpet> originalCarpets = carpets.map((c) => c.clone()).toList();

      List<GroupCarpet> groups = _algorithmService.buildGroups(
        carpets: carpets,
        minWidth: widget.minWidth,
        maxWidth: widget.maxWidth,
        tolerance: widget.tolerance,
        selectedMode: widget.groupingMode,
        selectedSortType: widget.sortType,
      );

      setState(() {
        _progress = 0.6;
        _statusMessage = "Generated ${groups.length} groups";
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // Step 3: Collect remaining carpets
      List<Carpet> remaining = carpets.where((c) => c.isAvailable).toList();

      setState(() {
        _progress = 0.7;
        _statusMessage = "Generating suggestions...";
      });

      // Step 4: Generate suggestions (70% - 80% progress)
      List<List<GroupCarpet>>? suggestedGroups;
      if (remaining.isNotEmpty) {
        suggestedGroups = _algorithmService.generateSuggestions(
          remaining: remaining,
          minWidth: widget.minWidth,
          maxWidth: widget.maxWidth,
          tolerance: widget.tolerance,
        );
      }

      setState(() {
        _progress = 0.8;
        _statusMessage = "Creating output file...";
      });

      // Step 5: Generate output Excel file (80% - 95% progress)
      Directory appDir = await getApplicationDocumentsDirectory();
      String timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')[0];
      String outputPath = '${appDir.path}/cut_optimizer_result_$timestamp.xlsx';

      await _dataService.writeOutputExcel(
        path: outputPath,
        groups: groups,
        remaining: remaining,
        minWidth: widget.minWidth,
        maxWidth: widget.maxWidth,
        toleranceLength: widget.tolerance,
        originals: originalCarpets,
        suggestedGroups: suggestedGroups,
      );

      setState(() {
        _progress = 0.95;
        _statusMessage = "Finalizing...";
      });

      await Future.delayed(const Duration(milliseconds: 300));

      // Step 6: Complete (100% progress)
      setState(() {
        _progress = 1.0;
        _statusMessage = "Execution complete!";
      });

      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to results screen automatically
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              groups: groups,
              remaining: remaining,
              outputFilePath: outputPath,
              minWidth: widget.minWidth,
              maxWidth: widget.maxWidth,
              tolerance: widget.tolerance,
              originalGroups: originalCarpets,
              suggestedGroups: suggestedGroups,
              config: widget.config,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isExecuting = false;
        _progress = 0.0;
        _statusMessage = "Error: ${e.toString()}";
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Execution failed: ${e.toString()}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
          onPressed: _isExecuting ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BackgroundService.getBackgroundDecoration(
          widget.config.backgroundImage,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B4EEB).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "READY TO EXECUTE",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              color: Colors.blue.shade900,
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Progress Indicator (from widget)
                          ExecutionProgressIndicator(progress: _progress),

                          const SizedBox(height: 24),

                          // Status Message
                          Text(
                            _statusMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Action Buttons (from widget)
                          ExecutionActionButtons(
                            isExecuting: _isExecuting,
                            onStart: _startExecution,
                            onCancel: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
