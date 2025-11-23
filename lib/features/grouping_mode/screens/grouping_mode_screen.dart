import 'package:flutter/material.dart';
import '../../../core/enums.dart';
import '../../../core/widgets/radio_option_tile.dart';
import '../../execution/screens/execution_screen.dart';

class GroupingModeScreen extends StatefulWidget {
  final String filePath;
  final int minWidth;
  final int maxWidth;
  final int tolerance;
  final SortType sortType;

  const GroupingModeScreen({
    super.key,
    required this.filePath,
    required this.minWidth,
    required this.maxWidth,
    required this.tolerance,
    required this.sortType,
  });

  @override
  State<GroupingModeScreen> createState() => _GroupingModeScreenState();
}

class _GroupingModeScreenState extends State<GroupingModeScreen> {
  GroupingMode _selectedMode = GroupingMode.allCombinations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.blue.shade900),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "GROUPING MODE",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 40),
              RadioOptionTile<GroupingMode>(
                value: GroupingMode.allCombinations,
                groupValue: _selectedMode,
                label: "all combinations",
                onChanged: (val) => setState(() => _selectedMode = val!),
              ),
              RadioOptionTile<GroupingMode>(
                value: GroupingMode.noMainRepeat,
                groupValue: _selectedMode,
                label: "combinations rep exclude main",
                onChanged: (val) => setState(() => _selectedMode = val!),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ExecutionScreen(
                          filePath: widget.filePath,
                          minWidth: widget.minWidth,
                          maxWidth: widget.maxWidth,
                          tolerance: widget.tolerance,
                          sortType: widget.sortType,
                          groupingMode: _selectedMode,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1), // Corporate Blue
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Next >",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
