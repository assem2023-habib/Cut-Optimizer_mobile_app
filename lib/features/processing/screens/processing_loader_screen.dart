import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/enums.dart';
import '../../../services/data_service.dart';
import '../../../services/algorithm_service.dart';
import '../../../services/results_storage_service.dart';
import '../../../services/file_store_service.dart';
import '../../../core/state/app_state_provider.dart';
import '../../../models/carpet.dart';
import '../../../models/group_carpet.dart';
import '../../results/screens/results_screen.dart';
import '../../../models/config.dart';

import '../widgets/loader/main_loader.dart';
import '../widgets/loader/pulsing_glow.dart';
import '../widgets/loader/animated_dots.dart';

/// شاشة التحميل أثناء المعالجة (Processing Loader)
/// تعرض رسوم متحركة أثناء معالجة البيانات
class ProcessingLoaderScreen extends StatefulWidget {
  final String filePath;
  final int minWidth;
  final int maxWidth;
  final int tolerance;
  final SortType sortType;
  final GroupingMode groupingMode;
  final Config config;

  const ProcessingLoaderScreen({
    super.key,
    required this.filePath,
    required this.minWidth,
    required this.maxWidth,
    required this.tolerance,
    required this.sortType,
    required this.groupingMode,
    required this.config,
  });

  @override
  State<ProcessingLoaderScreen> createState() => _ProcessingLoaderScreenState();
}

class _ProcessingLoaderScreenState extends State<ProcessingLoaderScreen> {
  final DataService _dataService = DataService();
  final AlgorithmService _algorithmService = AlgorithmService();
  String _statusMessage = 'جاري بدء المعالجة...';
  String? _error;

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    try {
      // Step 1: Read input Excel file
      setState(() {
        _statusMessage = 'قراءة ملف Excel...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      List<Carpet> carpets = await _dataService.readInputExcel(
        widget.filePath,
        pairOddMode: widget.config.pairOddMode,
      );

      // Free up memory after reading
      FileStoreService().clear();

      if (carpets.isEmpty) {
        throw Exception("لم يتم العثور على بيانات صالحة في الملف");
      }

      setState(() {
        _statusMessage = 'تم تحميل ${carpets.length} قطعة';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 2: Execute algorithm
      setState(() {
        _statusMessage = 'بناء المجموعات...';
      });

      List<Carpet> originalCarpets = carpets.map((c) => c.clone()).toList();

      // Get pathLength from the selected machine size
      int pathLength = 0;
      for (var size in widget.config.machineSizes) {
        if (size.maxWidth == widget.maxWidth) {
          pathLength = size.pathLength;
          break;
        }
      }

      List<GroupCarpet> groups = _algorithmService.buildGroups(
        carpets: carpets,
        minWidth: widget.minWidth,
        maxWidth: widget.maxWidth,
        tolerance: widget.tolerance,
        selectedMode: widget.groupingMode,
        selectedSortType: widget.sortType,
        pathLength: pathLength,
      );

      setState(() {
        _statusMessage = 'تم إنشاء ${groups.length} مجموعة';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 3: Collect remaining carpets
      List<Carpet> remaining = carpets.where((c) => c.isAvailable).toList();

      setState(() {
        _statusMessage = 'إنشاء الاقتراحات...';
      });

      // Step 4: Generate suggestions
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
        _statusMessage = 'إنشاء ملف النتائج...';
      });

      // Step 5: Generate output Excel file
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
        measurementUnit: widget.config.measurementUnit,
        pathLength: pathLength,
      );

      setState(() {
        _statusMessage = 'حفظ النتائج...';
      });

      // Step 6: Save results to SharedPreferences
      await ResultsStorageService.instance.saveResults(
        groups: groups,
        remaining: remaining,
        originalGroups: originalCarpets,
        suggestedGroups: suggestedGroups,
        outputFilePath: outputPath,
        minWidth: widget.minWidth,
        maxWidth: widget.maxWidth,
        tolerance: widget.tolerance,
      );

      // تحديث الحالة المشتركة
      if (mounted) {
        final appState = AppStateProvider.of(context);
        appState.updateResults(
          groups: groups,
          remaining: remaining,
          originalGroups: originalCarpets,
          suggestedGroups: suggestedGroups,
          outputFilePath: outputPath,
          minWidth: widget.minWidth,
          maxWidth: widget.maxWidth,
          tolerance: widget.tolerance,
        );
      }

      setState(() {
        _statusMessage = 'الانتهاء...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 7: Navigate to ResultsScreen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              groups: groups,
              remaining: remaining,
              originalGroups: originalCarpets,
              suggestedGroups: suggestedGroups,
              outputFilePath: outputPath,
              minWidth: widget.minWidth,
              maxWidth: widget.maxWidth,
              tolerance: widget.tolerance,
              config: widget.config,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  'حدث خطأ أثناء المعالجة',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('عودة وتعديل الخيارات'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // background
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الدائرة المتحركة الرئيسية مع التوهج
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // التوهج الخلفي
                      const PulsingGlow(),
                      // الدائرة الرئيسية
                      const MainLoader(),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // النص الرئيسي
                  const Text(
                    'جاري المعالجة...',
                    style: TextStyle(
                      color: Color(0xFF1F2937), // gray-800
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // الوصف
                  Text(
                    _statusMessage,
                    style: const TextStyle(
                      color: Color(0xFF4B5563), // gray-600
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // النقاط المتحركة
                  const AnimatedDots(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
