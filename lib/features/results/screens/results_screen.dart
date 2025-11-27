import 'package:flutter/material.dart';
import '../../../models/carpet.dart';
import '../../../models/group_carpet.dart';
import '../widgets/result_card.dart';
import '../../../services/report_service.dart';

class ResultsScreen extends StatelessWidget {
  final List<GroupCarpet> groups;
  final List<Carpet> remaining;
  final String outputFilePath;
  final int minWidth;
  final int maxWidth;
  final int tolerance;
  final List<Carpet>? originalGroups;
  final List<List<GroupCarpet>>? suggestedGroups;

  const ResultsScreen({
    super.key,
    required this.groups,
    required this.remaining,
    required this.outputFilePath,
    required this.minWidth,
    required this.maxWidth,
    required this.tolerance,
    this.originalGroups,
    this.suggestedGroups,
  });

  Future<void> _exportToExcel(BuildContext context) async {
    try {
      final reportService = ReportService();
      await reportService.generateReport(
        groups: groups,
        remaining: remaining,
        minWidth: minWidth,
        maxWidth: maxWidth,
        tolerance: tolerance,
        outputPath: outputFilePath,
        originalGroups: originalGroups,
        suggestedGroups: suggestedGroups,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Excel file exported to: $outputFilePath'),
            backgroundColor: Color(0xFF28A745),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error exporting Excel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Icon(Icons.grid_on, color: Color(0xFF6B4EEB), size: 24),
            SizedBox(width: 12),
            Flexible(
              child: Text(
                'Processing Results',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _exportToExcel(context),
              icon: Icon(Icons.download, size: 18),
              label: Text(
                'Export Excel',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B4EEB),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final group = groups[index];

            // Calculate total height from carpets in group
            final totalHeight = group.items.fold<double>(
              0.0,
              (sum, carpet) => sum + carpet.height,
            );

            // Determine status based on whether it's in remaining list
            final status = 'Completed'; // Default to completed for now

            return ResultCard(
              groupId: 'GRP-${(index + 1).toString().padLeft(3, '0')}',
              width: group.totalWidth.toDouble(),
              height: totalHeight,
              quantity: group.items.length,
              status: status,
            );
          },
        ),
      ),
    );
  }
}
