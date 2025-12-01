import 'package:flutter/material.dart';
import '../../../shared/layout/main_layout.dart';
import '../../../models/config.dart';
import '../widgets/success_card.dart';
import '../widgets/loom_selection.dart';
import '../widgets/selected_loom_details.dart';
import '../widgets/sort_options.dart';
import '../widgets/repeat_main_option.dart';
import '../widgets/processing_action_buttons.dart';
import '../screens/processing_loader_screen.dart';
import '../../../core/enums.dart';

/// شاشة خيارات المعالجة (Processing Options)
/// تسمح باختيار النول وخيارات الترتيب قبل بدء المعالجة
class ProcessingOptionsScreen extends StatefulWidget {
  final String fileName;
  final int fileSize;
  final String? filePath; // Add file path parameter
  final Config config;

  const ProcessingOptionsScreen({
    super.key,
    required this.fileName,
    required this.fileSize,
    this.filePath,
    required this.config,
  });

  @override
  State<ProcessingOptionsScreen> createState() =>
      _ProcessingOptionsScreenState();
}

class _ProcessingOptionsScreenState extends State<ProcessingOptionsScreen> {
  Config? _config;
  int? _selectedLoomIndex;
  String _sortOption = 'length'; // length, width, quantity
  String _repeatMain = 'repeat'; // repeat, no-repeat
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    // Use widget.config directly instead of loading
    setState(() {
      _config = widget.config;
      _isLoading = false;
    });
  }

  void _startProcessing() {
    if (_selectedLoomIndex == null || _config == null) return;

    final selectedLoom = _config!.machineSizes[_selectedLoomIndex!];

    // Convert sort option to SortType
    SortType sortType;
    switch (_sortOption) {
      case 'width':
        sortType = SortType.sortByWidth;
        break;
      case 'quantity':
        sortType = SortType.sortByQuantity;
        break;
      case 'length':
      default:
        sortType = SortType.sortByHeight;
        break;
    }

    // Convert repeat option to GroupingMode
    GroupingMode groupingMode = _repeatMain == 'no-repeat'
        ? GroupingMode.noMainRepeat
        : GroupingMode.allCombinations;

    // Navigate to ProcessingLoaderScreen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProcessingLoaderScreen(
          filePath: widget.filePath ?? '',
          minWidth: selectedLoom.minWidth,
          maxWidth: selectedLoom.maxWidth,
          tolerance: selectedLoom.tolerance,
          sortType: sortType,
          groupingMode: groupingMode,
          config: _config!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _config == null) {
      return MainLayout(
        currentPage: 'upload',
        showBottomNav: false,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return MainLayout(
      currentPage: 'upload', // Still on upload flow
      showBottomNav: false, // Hide during processing setup
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // العنوان
            const Text(
              'خيارات المعالجة',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'اختر النول المناسب وحدد خيارات الترتيب',
              style: TextStyle(color: Color(0xFF4B5563), fontSize: 14),
            ),

            const SizedBox(height: 24),

            // 1. Success Card
            SuccessCard(fileName: widget.fileName, fileSize: widget.fileSize),

            const SizedBox(height: 24),

            // 2. Loom Selection
            LoomSelection(
              looms: _config!.machineSizes,
              selectedIndex: _selectedLoomIndex,
              onSelect: (index) {
                setState(() {
                  _selectedLoomIndex = index;
                });
              },
            ),

            const SizedBox(height: 16),

            // 3. Selected Loom Details
            if (_selectedLoomIndex != null)
              SelectedLoomDetails(
                loom: _config!.machineSizes[_selectedLoomIndex!],
              ),

            if (_selectedLoomIndex != null) const SizedBox(height: 24),

            // 4. Sort Options
            SortOptions(
              selected: _sortOption,
              onSelect: (option) {
                setState(() {
                  _sortOption = option;
                });
              },
            ),

            const SizedBox(height: 24),

            // 5. Repeat Main Option
            RepeatMainOption(
              selected: _repeatMain,
              onSelect: (option) {
                setState(() {
                  _repeatMain = option;
                });
              },
            ),

            const SizedBox(height: 24),

            // 6. Action Buttons
            Row(
              children: [
                // زر الرجوع
                Expanded(
                  child: ProcessingBackButton(
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ),

                const SizedBox(width: 12),

                // زر بدء المعالجة
                Expanded(
                  flex: 2,
                  child: ProcessButton(
                    enabled: _selectedLoomIndex != null,
                    onTap: _startProcessing,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
