import 'package:flutter/material.dart';

class ProcessingOptionsPanel extends StatelessWidget {
  final bool advancedGrouping;
  final bool optimizeResults;
  final bool generateReport;
  final ValueChanged<bool> onAdvancedGroupingChanged;
  final ValueChanged<bool> onOptimizeResultsChanged;
  final ValueChanged<bool> onGenerateReportChanged;

  const ProcessingOptionsPanel({
    super.key,
    required this.advancedGrouping,
    required this.optimizeResults,
    required this.generateReport,
    required this.onAdvancedGroupingChanged,
    required this.onOptimizeResultsChanged,
    required this.onGenerateReportChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFFF0FFF4), // Pale Mint Green
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF6B4EEB), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Processing Options',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Checkboxes
          _buildCheckboxOption(
            'Advanced Grouping',
            advancedGrouping,
            onAdvancedGroupingChanged,
          ),
          SizedBox(height: 12),
          _buildCheckboxOption(
            'Optimize Results',
            optimizeResults,
            onOptimizeResultsChanged,
          ),
          SizedBox(height: 12),
          _buildCheckboxOption(
            'Generate Report',
            generateReport,
            onGenerateReportChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? Color(0xFF6B4EEB) : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: value ? Color(0xFF6B4EEB) : Color(0xFFCCCCCC),
                width: 2,
              ),
            ),
            child: value
                ? Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
          SizedBox(width: 10),
          Text(label, style: TextStyle(fontSize: 14, color: Color(0xFF333333))),
        ],
      ),
    );
  }
}
