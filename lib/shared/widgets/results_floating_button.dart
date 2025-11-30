import 'package:cut_optimizer_mobile/core/enums.dart';
import 'package:flutter/material.dart';
import '../../core/state/app_state_provider.dart';
import '../../features/results/screens/results_screen.dart';
import '../../models/config.dart';

class ResultsFloatingButton extends StatelessWidget {
  const ResultsFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);
    final hasData = appState.hasProcessedData;

    return FloatingActionButton(
      onPressed: hasData
          ? () {
              // إنشاء كائن Config مؤقت من القيم المخزنة في الحالة
              // لأن ResultsScreen لا تزال تتطلب Config
              final tempConfig = Config(
                minWidth: appState.minWidth ?? 0,
                maxWidth: appState.maxWidth ?? 0,
                toleranceLength: appState.tolerance ?? 0,
                maxPartner: 2, // قيمة افتراضية
                startWithLargest: true, // قيمة افتراضية
                allowSplitRows: false, // قيمة افتراضية
                theme: 'light', // قيمة افتراضية
                backgroundImage: '', // قيمة افتراضية
                backgroundType: BackgroundType.gradient, // قيمة افتراضية
                machineSizes: [], // قيمة افتراضية
                selectedMode: GroupingMode.allCombinations, // قيمة افتراضية
                selectedSortType: SortType.sortByQuantity, // قيمة افتراضية
                measurementUnit: MeasurementUnit.cm, // قيمة افتراضية
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultsScreen(
                    groups: appState.groups!,
                    remaining: appState.remaining!,
                    originalGroups: appState.originalGroups,
                    suggestedGroups: appState.suggestedGroups,
                    outputFilePath: appState.outputFilePath ?? '',
                    minWidth: appState.minWidth ?? 0,
                    maxWidth: appState.maxWidth ?? 0,
                    tolerance: appState.tolerance ?? 0,
                    config: tempConfig,
                  ),
                ),
              );
            }
          : null, // تعطيل الزر إذا لم تكن هناك بيانات
      backgroundColor: hasData ? const Color(0xFF16A34A) : Colors.grey[400],
      elevation: hasData ? 6 : 0,
      child: Icon(
        Icons.assignment_turned_in,
        color: hasData ? Colors.white : Colors.grey[200],
      ),
    );
  }
}
