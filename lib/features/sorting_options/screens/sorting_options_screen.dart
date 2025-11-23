import 'package:flutter/material.dart';
import '../../../core/enums.dart';
import '../../../core/widgets/radio_option_tile.dart';
import '../../grouping_mode/screens/grouping_mode_screen.dart';

class SortingOptionsScreen extends StatefulWidget {
  const SortingOptionsScreen({super.key});

  @override
  State<SortingOptionsScreen> createState() => _SortingOptionsScreenState();
}

class _SortingOptionsScreenState extends State<SortingOptionsScreen> {
  SortType _selectedSortType = SortType.sortByQuantity;

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
                "SORTING OPTIONS",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 40),
              RadioOptionTile<SortType>(
                value: SortType.sortByQuantity,
                groupValue: _selectedSortType,
                label: "Sort carpet by quantity",
                onChanged: (val) => setState(() => _selectedSortType = val!),
              ),
              RadioOptionTile<SortType>(
                value: SortType.sortByWidth,
                groupValue: _selectedSortType,
                label: "Sort carpet by width",
                onChanged: (val) => setState(() => _selectedSortType = val!),
              ),
              RadioOptionTile<SortType>(
                value: SortType.sortByHeight,
                groupValue: _selectedSortType,
                label: "Sort carpet by height",
                onChanged: (val) => setState(() => _selectedSortType = val!),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GroupingModeScreen(),
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
