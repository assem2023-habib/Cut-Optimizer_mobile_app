import 'package:flutter/material.dart';
import '../../../core/enums.dart';
import '../widgets/measurement_constraints_panel.dart';
import '../widgets/sort_configuration_panel.dart';
import '../widgets/processing_options_panel.dart';
import '../../execution/screens/execution_screen.dart';
import '../../../models/config.dart';
import '../../../services/background_service.dart';

class GroupingModeScreen extends StatefulWidget {
  final String filePath;
  final int minWidth;
  final int maxWidth;
  final int tolerance;
  final Config config;

  const GroupingModeScreen({
    super.key,
    required this.filePath,
    required this.minWidth,
    required this.maxWidth,
    required this.tolerance,
    required this.config,
  });

  @override
  State<GroupingModeScreen> createState() => _GroupingModeScreenState();
}

class _GroupingModeScreenState extends State<GroupingModeScreen> {
  // Measurement Controllers
  late TextEditingController _minWidthController;
  late TextEditingController _maxWidthController;
  late TextEditingController _toleranceController;

  // Sort Configuration
  SortType _selectedSortType = SortType.sortByHeight;

  // Processing Options
  bool _advancedGrouping = false;
  bool _optimizeResults = true;
  bool _generateReport = false;

  @override
  void initState() {
    super.initState();
    _minWidthController = TextEditingController(
      text: widget.minWidth.toString(),
    );
    _maxWidthController = TextEditingController(
      text: widget.maxWidth.toString(),
    );
    _toleranceController = TextEditingController(
      text: widget.tolerance.toString(),
    );
  }

  @override
  void dispose() {
    _minWidthController.dispose();
    _maxWidthController.dispose();
    _toleranceController.dispose();
    super.dispose();
  }

  void _startProcessing() {
    // Parse input values
    final minWidth = int.tryParse(_minWidthController.text);
    final maxWidth = int.tryParse(_maxWidthController.text);
    final tolerance = int.tryParse(_toleranceController.text);

    // Validate inputs
    if (minWidth == null || maxWidth == null || tolerance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter valid numbers for all measurement fields',
          ),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
      return;
    }

    if (minWidth < 0 || maxWidth < 0 || tolerance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All measurements must be positive numbers'),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
      return;
    }

    if (minWidth >= maxWidth) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Minimum width must be less than maximum width'),
          backgroundColor: Color(0xFFFF5252),
        ),
      );
      return;
    }

    // Determine grouping mode based on Advanced Grouping option
    GroupingMode groupingMode = _advancedGrouping
        ? GroupingMode.noMainRepeat
        : GroupingMode.allCombinations;

    // Navigate to execution screen with all configuration
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExecutionScreen(
          filePath: widget.filePath,
          minWidth: minWidth,
          maxWidth: maxWidth,
          tolerance: tolerance,
          sortType: _selectedSortType,
          groupingMode: groupingMode,
          optimizeResults: _optimizeResults,
          generateReport: _generateReport,
          config: widget.config,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Transparent to show background
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
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
              padding: EdgeInsets.all(24),
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(
                    0.9,
                  ), // Semi-transparent white
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(Icons.tune, color: Color(0xFF6B4EEB), size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Processing Conf',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),

                    // Three Panels
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 800) {
                          // Desktop: Horizontal layout
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: MeasurementConstraintsPanel(
                                  minWidthController: _minWidthController,
                                  maxWidthController: _maxWidthController,
                                  toleranceController: _toleranceController,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: SortConfigurationPanel(
                                  selectedSortType: _selectedSortType,
                                  onChanged: (value) =>
                                      setState(() => _selectedSortType = value),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: ProcessingOptionsPanel(
                                  advancedGrouping: _advancedGrouping,
                                  optimizeResults: _optimizeResults,
                                  generateReport: _generateReport,
                                  onAdvancedGroupingChanged: (value) =>
                                      setState(() => _advancedGrouping = value),
                                  onOptimizeResultsChanged: (value) =>
                                      setState(() => _optimizeResults = value),
                                  onGenerateReportChanged: (value) =>
                                      setState(() => _generateReport = value),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Mobile: Vertical layout
                          return Column(
                            children: [
                              MeasurementConstraintsPanel(
                                minWidthController: _minWidthController,
                                maxWidthController: _maxWidthController,
                                toleranceController: _toleranceController,
                              ),
                              SizedBox(height: 16),
                              SortConfigurationPanel(
                                selectedSortType: _selectedSortType,
                                onChanged: (value) =>
                                    setState(() => _selectedSortType = value),
                              ),
                              SizedBox(height: 16),
                              ProcessingOptionsPanel(
                                advancedGrouping: _advancedGrouping,
                                optimizeResults: _optimizeResults,
                                generateReport: _generateReport,
                                onAdvancedGroupingChanged: (value) =>
                                    setState(() => _advancedGrouping = value),
                                onOptimizeResultsChanged: (value) =>
                                    setState(() => _optimizeResults = value),
                                onGenerateReportChanged: (value) =>
                                    setState(() => _generateReport = value),
                              ),
                            ],
                          );
                        }
                      },
                    ),

                    SizedBox(height: 32),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _startProcessing,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
