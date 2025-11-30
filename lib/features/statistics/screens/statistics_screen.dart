import 'package:flutter/material.dart';
import '../../../shared/layout/main_layout.dart';
import '../../../models/group_carpet.dart';
import '../../../models/carpet.dart';
import '../../../utils/results_calculator.dart';
import '../widgets/key_metrics.dart';
import '../widgets/efficiency_chart.dart';
import '../widgets/performance_indicator.dart';
import '../widgets/detailed_stats.dart';
import '../widgets/tips_box.dart';

/// شاشة الإحصائيات (Statistics Screen)
/// رسوم بيانية وتحليلات شاملة
class StatisticsScreen extends StatelessWidget {
  final List<GroupCarpet> groups;
  final List<Carpet> remaining;
  final List<Carpet>? originalGroups;

  const StatisticsScreen({
    super.key,
    required this.groups,
    required this.remaining,
    this.originalGroups,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate statistics
    final efficiency = ResultsCalculator.calculateEfficiency(groups, remaining);
    final wastePercentage = ResultsCalculator.calculateWastePercentage(
      groups,
      remaining,
    );
    final totalArea = ResultsCalculator.calculateTotalArea(groups, remaining);
    final usedArea = ResultsCalculator.calculateUsedArea(groups);
    final wasteArea = ResultsCalculator.calculateWasteArea(groups, remaining);
    final totalGroups = ResultsCalculator.calculateTotalGroups(groups);
    final uniqueCuts = ResultsCalculator.calculateUniqueCuts(groups);
    final totalPieces = groups.fold(0, (sum, g) => sum + g.totalQty);
    final avgPiecesPerGroup = totalGroups > 0 ? totalPieces / totalGroups : 0.0;

    return MainLayout(
      currentPage: 'statistics',
      showBottomNav: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'الإحصائيات',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            // Key Metrics (4 بطاقات)
            KeyMetrics(
              efficiency: efficiency,
              usedArea: usedArea,
              wastePercentage: wastePercentage,
              totalGroups: totalGroups,
            ),

            const SizedBox(height: 24),

            // Efficiency Pie Chart
            EfficiencyChart(
              efficiency: efficiency,
              wastePercentage: wastePercentage,
            ),

            const SizedBox(height: 24),

            // Performance Indicator
            PerformanceIndicator(efficiency: efficiency),

            const SizedBox(height: 24),

            // Detailed Stats
            DetailedStats(
              totalArea: totalArea,
              usedArea: usedArea,
              wasteArea: wasteArea,
              totalGroups: totalGroups,
              totalCuts: uniqueCuts,
              avgPiecesPerGroup: avgPiecesPerGroup,
            ),

            const SizedBox(height: 16),

            // Tips
            const TipsBox(),

            // مسافة إضافية لتجنب تداخل مع BottomNavBar
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
