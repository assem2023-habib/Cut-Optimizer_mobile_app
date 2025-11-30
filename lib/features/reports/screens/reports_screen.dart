import 'package:flutter/material.dart';
import '../../../shared/layout/main_layout.dart';
import '../../../models/group_carpet.dart';
import '../../../models/carpet.dart';
import '../../../utils/results_calculator.dart';
import '../widgets/cuts_tab.dart';
import '../widgets/remaining_tab.dart';
import '../widgets/audit_tab.dart';
import '../widgets/waste_tab.dart';
import '../widgets/summary_footer.dart';
import '../widgets/tab_button.dart';

/// شاشة التقارير المفصلة (Reports Screen)
/// نظام Tabs مع 4 تبويبات: القصات + المتبقي + التدقيق + الهادر
class ReportsScreen extends StatefulWidget {
  final List<GroupCarpet> groups;
  final List<Carpet> remaining;
  final List<Carpet> originalGroups; // For audit

  const ReportsScreen({
    super.key,
    required this.groups,
    required this.remaining,
    required this.originalGroups,
  });

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final totalGroups = ResultsCalculator.calculateTotalGroups(widget.groups);
    final totalRemaining = widget.remaining.fold(
      0,
      (sum, item) => sum + item.remQty,
    );

    return MainLayout(
      currentPage: 'reports',
      showBottomNav: true,
      hasProcessedData: true,
      groups: widget.groups,
      remaining: widget.remaining,
      originalGroups: widget.originalGroups,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // العنوان
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'التقارير المفصلة',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Tabs
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                TabButton(
                  label: 'القصات',
                  count: widget.groups.length,
                  isActive: _activeTab == 0,
                  onTap: () => setState(() => _activeTab = 0),
                ),
                TabButton(
                  label: 'المتبقي',
                  count: widget.remaining.length,
                  isActive: _activeTab == 1,
                  onTap: () => setState(() => _activeTab = 1),
                ),
                TabButton(
                  label: 'التدقيق',
                  count: widget.originalGroups.length,
                  isActive: _activeTab == 2,
                  onTap: () => setState(() => _activeTab = 2),
                ),
                TabButton(
                  label: 'الهادر',
                  count: widget.groups.length,
                  isActive: _activeTab == 3,
                  onTap: () => setState(() => _activeTab = 3),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // محتوى التبويب
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildTabContent(),
            ),
          ),

          // Summary Footer
          SummaryFooter(
            totalGroups: totalGroups,
            totalRemaining: totalRemaining,
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_activeTab) {
      case 0:
        return CutsTab(groups: widget.groups);
      case 1:
        return RemainingTab(remaining: widget.remaining);
      case 2:
        return AuditTab(
          originalGroups: widget.originalGroups,
          groups: widget.groups,
          remaining: widget.remaining,
        );
      case 3:
        return WasteTab(groups: widget.groups);
      default:
        return Container();
    }
  }
}
