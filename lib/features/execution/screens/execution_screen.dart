import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/enums.dart';
import '../../../services/data_service.dart';
import '../../../services/algorithm_service.dart';
import '../../../models/carpet.dart';
import '../../../models/group_carpet.dart';
import '../../results/screens/results_screen.dart';

class ExecutionScreen extends StatefulWidget {
  final String filePath;
  final int minWidth;
  final int maxWidth;
  final int tolerance;
  final SortType sortType;
  final GroupingMode groupingMode;
  final bool optimizeResults;
  final bool generateReport;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue.shade900),
          onPressed: _isExecuting ? null : () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
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
              const Spacer(),
              // Circular Progress Indicator
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.blue.shade50,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.blue.shade700,
                      ),
                    ),
                    Center(
                      child: Text(
                        "${(_progress * 100).toInt()}%",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Status Message
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const Spacer(),
              // Start Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isExecuting ? null : _startExecution,
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text(
                    "Start Execution",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isExecuting
                      ? null
                      : () {
                          Navigator.of(context).pop();
                        },
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
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
