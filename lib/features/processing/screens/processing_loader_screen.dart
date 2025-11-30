import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/enums.dart';
import '../../../services/data_service.dart';
import '../../../services/algorithm_service.dart';
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

      List<Carpet> carpets = await _dataService.readInputExcel(widget.filePath);

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

      List<GroupCarpet> groups = _algorithmService.buildGroups(
        carpets: carpets,
        minWidth: widget.minWidth,
        maxWidth: widget.maxWidth,
        tolerance: widget.tolerance,
        selectedMode: widget.groupingMode,
        selectedSortType: widget.sortType,
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
      );

      setState(() {
        _statusMessage = 'الانتهاء...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Step 6: Navigate to ResultsScreen
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
