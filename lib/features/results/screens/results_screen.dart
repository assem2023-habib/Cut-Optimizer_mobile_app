import 'package:flutter/material.dart';
import '../../../shared/layout/main_layout.dart';
import '../../../models/group_carpet.dart';
import '../../../models/carpet.dart';
import '../../../models/config.dart';
import '../../../utils/results_calculator.dart';
import '../../reports/screens/reports_screen.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../widgets/success_message.dart';
import '../widgets/statistics_cards.dart';
import '../widgets/area_info.dart';
import '../widgets/cuts_summary.dart';
import '../widgets/remaining_pieces.dart';
import '../widgets/action_button.dart';
import '../widgets/download_excel_button.dart';

/// شاشة النتائج (Results Screen)
/// تعرض ملخص النتائج بعد المعالجة من البيانات الحقيقية
class ResultsScreen extends StatelessWidget {
  final List<GroupCarpet> groups;
  final List<Carpet> remaining;
  final List<Carpet>? originalGroups;
  final List<List<GroupCarpet>>? suggestedGroups;
  final String outputFilePath;
  final int minWidth;
  final int maxWidth;
  final int tolerance;
  final Config config;

  const ResultsScreen({
    super.key,
    required this.groups,
    required this.remaining,
    this.originalGroups,
    this.suggestedGroups,
    required this.outputFilePath,
    required this.minWidth,
    required this.maxWidth,
    required this.tolerance,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    // حساب الإحصائيات من البيانات الحقيقية
    final efficiency = ResultsCalculator.calculateEfficiency(groups, remaining);
    final wastePercentage = ResultsCalculator.calculateWastePercentage(
      groups,
      remaining,
    );
    final totalArea = ResultsCalculator.calculateTotalArea(groups, remaining);
    final usedArea = ResultsCalculator.calculateUsedArea(groups);
    final wasteArea = ResultsCalculator.calculateWasteArea(groups, remaining);
    final uniqueCuts = ResultsCalculator.calculateUniqueCuts(groups);

    return MainLayout(
      currentPage: 'results',
      showBottomNav: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'النتائج',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            // Success Message
            const SuccessMessage(),

            const SizedBox(height: 24),

            // Statistics Cards
            StatisticsCards(
              efficiency: efficiency,
              wastePercentage: wastePercentage,
              totalGroups: groups.length,
              totalCuts: uniqueCuts,
            ),

            const SizedBox(height: 24),

            // Area Info
            AreaInfo(
              totalArea: totalArea,
              usedArea: usedArea,
              wasteArea: wasteArea,
            ),

            const SizedBox(height: 24),

            // Cuts Summary
            CutsSummary(groups: groups),

            const SizedBox(height: 24),

            // Remaining Pieces
            if (remaining.isNotEmpty) RemainingPieces(remaining: remaining),

            if (remaining.isNotEmpty) const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: 'التقارير المفصلة',
                    icon: Icons.description,
                    isPrimary: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportsScreen(
                            groups: groups,
                            remaining: remaining,
                            originalGroups: originalGroups ?? [],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionButton(
                    label: 'الإحصائيات',
                    icon: Icons.bar_chart,
                    isPrimary: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatisticsScreen(
                            groups: groups,
                            remaining: remaining,
                            originalGroups: originalGroups,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Download Excel Button
            DownloadExcelButton(filePath: outputFilePath),

            // مسافة إضافية لتجنب تداخل مع BottomNavBar
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }
}
