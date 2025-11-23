import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/carpet.dart';
import '../../../models/group_carpet.dart';

class ResultsScreen extends StatelessWidget {
  final List<GroupCarpet> groups;
  final List<Carpet> remaining;
  final String outputFilePath;

  const ResultsScreen({
    super.key,
    required this.groups,
    required this.remaining,
    required this.outputFilePath,
  });

  Future<void> _shareFile(BuildContext context) async {
    try {
      final file = File(outputFilePath);
      if (await file.exists()) {
        await Share.shareXFiles([
          XFile(outputFilePath),
        ], subject: 'Cut Optimizer Results');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("File not found"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error sharing file: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate summary statistics
    final int totalGroups = groups.length;
    int totalCarpetsUsed = 0;
    for (final group in groups) {
      totalCarpetsUsed += group.carpets.length as int;
    }
    final int totalRemaining = remaining.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue.shade900),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                "PROCESSING COMPLETE",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade50,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      "Groups",
                      totalGroups.toString(),
                      Icons.group_work,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "Used",
                      totalCarpetsUsed.toString(),
                      Icons.check_circle_outline,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      "Remaining",
                      totalRemaining.toString(),
                      Icons.inventory_2_outlined,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: groups.isEmpty
                      ? Center(
                          child: Text(
                            "No groups generated",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SingleChildScrollView(
                            child: DataTable(
                              headingTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                                fontSize: 14,
                              ),
                              dataTextStyle: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 13,
                              ),
                              columns: const [
                                DataColumn(label: Text("Group ID")),
                                DataColumn(label: Text("Carpets")),
                                DataColumn(label: Text("Total Width")),
                                DataColumn(label: Text("Ref Height")),
                              ],
                              rows: groups.take(10).map((group) {
                                int totalWidth = 0;
                                for (final cu in group.carpets) {
                                  totalWidth += cu.carpet.width;
                                }
                                return DataRow(
                                  cells: [
                                    DataCell(Text("G${group.groupId}")),
                                    DataCell(Text("${group.carpets.length}")),
                                    DataCell(Text("$totalWidth cm")),
                                    DataCell(Text("${group.refHeight} cm")),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                ),
              ),
              if (groups.length > 10)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Showing first 10 of ${groups.length} groups",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _shareFile(context),
                  icon: const Icon(Icons.share, color: Colors.white),
                  label: const Text(
                    "Share Results",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    "New Process",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
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

  Widget _buildSummaryCard(
    String label,
    String value,
    IconData icon,
    MaterialColor color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: color.shade700, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color.shade900,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color.shade700)),
        ],
      ),
    );
  }
}
