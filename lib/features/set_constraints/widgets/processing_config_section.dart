import 'package:flutter/material.dart';
import '../../../models/config.dart';
import '../../../core/enums.dart';

class ProcessingConfigSection extends StatefulWidget {
  final Config config;
  final Function(
    MachineSize? machine,
    String tolerance,
    SortType sortType,
    GroupingMode groupingMode,
  )
  onChanged;

  const ProcessingConfigSection({
    super.key,
    required this.config,
    required this.onChanged,
  });

  @override
  State<ProcessingConfigSection> createState() =>
      _ProcessingConfigSectionState();
}

class _ProcessingConfigSectionState extends State<ProcessingConfigSection> {
  // State for Panel A
  MachineSize? selectedMachineSize;
  final TextEditingController toleranceController = TextEditingController(
    text: "5",
  );

  // State for Panel B
  SortType sortOption = SortType.sortByHeight;

  // State for Panel C
  GroupingMode processingOption = GroupingMode.noMainRepeat;

  @override
  void initState() {
    super.initState();
    // Default selection for Panel A
    if (widget.config.machineSizes.isNotEmpty) {
      selectedMachineSize = widget.config.machineSizes[0];
    }
    toleranceController.addListener(_notifyParent);
    // Initial notification
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyParent());
  }

  void _notifyParent() {
    widget.onChanged(
      selectedMachineSize,
      toleranceController.text,
      sortOption,
      processingOption,
    );
  }

  @override
  void dispose() {
    toleranceController.removeListener(_notifyParent);
    toleranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive layout: Column on small screens, Row on large screens
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide = constraints.maxWidth > 800;

        List<Widget> panels = [
          _buildMeasurementPanel(),
          const SizedBox(width: 16, height: 16),
          _buildSortPanel(),
          const SizedBox(width: 16, height: 16),
          _buildOptionsPanel(),
        ];

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: panels[0]),
              const SizedBox(width: 16),
              Expanded(child: panels[2]),
              const SizedBox(width: 16),
              Expanded(child: panels[4]),
            ],
          );
        } else {
          return Column(children: panels);
        }
      },
    );
  }

  Widget _buildGlassContainer({
    required Widget child,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(12), child: child),
    );
  }

  Widget _buildHeader(String title, IconData icon, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // Panel A: Measurement Constraints
  Widget _buildMeasurementPanel() {
    const accentColor = Color(0xFF6B9EF5); // Soft Blue

    return _buildGlassContainer(
      accentColor: accentColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              "Measurement Constraints",
              Icons.straighten,
              accentColor,
            ),

            // Dropdown
            Text(
              "Machine Size",
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MachineSize>(
                  value: selectedMachineSize,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: accentColor),
                  items: widget.config.machineSizes.map((size) {
                    return DropdownMenuItem<MachineSize>(
                      value: size,
                      child: Text(
                        "${size.name} (${size.minWidth}-${size.maxWidth})",
                        style: const TextStyle(
                          fontFamily: 'Segoe UI',
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedMachineSize = val;
                      _notifyParent();
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Tolerance Input
            Text(
              "Tolerance",
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: TextField(
                controller: toleranceController,
                style: const TextStyle(fontFamily: 'Segoe UI', fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Panel B: Sort Configuration
  Widget _buildSortPanel() {
    const accentColor = Color(0xFFFF9800); // Light Orange

    return _buildGlassContainer(
      accentColor: accentColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Sort Configuration", Icons.sort, accentColor),

            _buildRadioButton("Width", SortType.sortByWidth, sortOption, (val) {
              setState(() {
                sortOption = val!;
                _notifyParent();
              });
            }, accentColor),
            _buildRadioButton("Quantity", SortType.sortByQuantity, sortOption, (
              val,
            ) {
              setState(() {
                sortOption = val!;
                _notifyParent();
              });
            }, accentColor),
            _buildRadioButton("Height", SortType.sortByHeight, sortOption, (
              val,
            ) {
              setState(() {
                sortOption = val!;
                _notifyParent();
              });
            }, accentColor),
          ],
        ),
      ),
    );
  }

  // Panel C: Processing Options
  Widget _buildOptionsPanel() {
    const accentColor = Color(0xFF4ECDC4); // Soft Teal

    return _buildGlassContainer(
      accentColor: accentColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Processing Options", Icons.settings, accentColor),

            Tooltip(
              message: "Process all possible combinations",
              child: _buildRadioButton(
                "All Combinations",
                GroupingMode.allCombinations,
                processingOption,
                (val) {
                  setState(() {
                    processingOption = val!;
                    _notifyParent();
                  });
                },
                accentColor,
              ),
            ),
            Tooltip(
              message: "Avoid repeating the main pattern",
              child: _buildRadioButton(
                "No Main Repeat",
                GroupingMode.noMainRepeat,
                processingOption,
                (val) {
                  setState(() {
                    processingOption = val!;
                    _notifyParent();
                  });
                },
                accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton<T>(
    String label,
    T value,
    T groupValue,
    ValueChanged<T?> onChanged,
    Color activeColor,
  ) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Radio<T>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: activeColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontFamily: 'Segoe UI', fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
