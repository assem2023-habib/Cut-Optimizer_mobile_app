import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../models/carpet.dart';
import '../../../models/group_carpet.dart';
import '../widgets/result_card.dart';
import '../../../services/report_service.dart';
import '../../../services/background_service.dart';
import '../../../models/config.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

class ResultsScreen extends StatelessWidget {
  final List<GroupCarpet> groups;
  final List<Carpet> remaining;
  final String outputFilePath;
  final int minWidth;
  final int maxWidth;
  final int tolerance;
  final List<Carpet>? originalGroups;
  final List<List<GroupCarpet>>? suggestedGroups;
  final Config? config;

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
    this.config,
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
        // Share the file to allow saving/sending
        await Share.shareXFiles([
          XFile(outputFilePath),
        ], text: 'Cut Optimizer Results');
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

  Future<void> _openExcel(BuildContext context) async {
    try {
      final result = await OpenFile.open(outputFilePath);
      if (result.type != ResultType.done && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open file: ${result.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
        title: Row(
          children: [
            const Icon(Icons.grid_on, color: Color(0xFF6B4EEB), size: 24),
            const SizedBox(width: 12),
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
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () => _exportToExcel(context),
              icon: const Icon(Icons.download, size: 18),
              label: const Text(
                'Export Excel',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B4EEB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: config != null
            ? BackgroundService.getBackgroundDecoration(config!.backgroundImage)
            : const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F7FA), Color(0xFFE8EAF6)],
                ),
              ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
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
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
              ),
            ),
            child: ElevatedButton.icon(
              onPressed: () => _openExcel(context),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Excel File'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A745),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
