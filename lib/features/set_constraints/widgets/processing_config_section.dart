import 'dart:ui';
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
      toleranceController.text = selectedMachineSize!.tolerance.toString();
    } else {
      // Fallback default as requested
      selectedMachineSize = MachineSize(
        name: "Standard",
        minWidth: 370,
        maxWidth: 400,
        tolerance: 5,
      );
      toleranceController.text = "5";
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
    // Main Container Style
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.25),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6B4EEB).withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Title
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0, left: 4.0),
                child: Text(
                  "Processing Configuration",
                  style: TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 21.3, // ~16pt
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              // Panels Layout
              LayoutBuilder(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassContainer({
    required Widget child,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
      ),
      child: child,
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
              fontSize: 17.3, // ~13pt
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
              Icons.straighten, // Ruler icon approximation
              accentColor,
            ),

            // Dropdown
            Text(
              "Machine Size:",
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.transparent),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MachineSize>(
                  value: selectedMachineSize,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: accentColor),
                  style: const TextStyle(
                    fontFamily: 'Segoe UI',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  dropdownColor: Colors.white,
                  items: widget.config.machineSizes.map((size) {
                    return DropdownMenuItem<MachineSize>(
                      value: size,
                      child: Text(
                        "${size.name} (${size.minWidth}-${size.maxWidth})",
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedMachineSize = val;
                      if (val != null) {
                        toleranceController.text = val.tolerance.toString();
                      }
                      _notifyParent();
                    });
                  },
                ),
              ),
            ),

            // Hidden but functional tolerance field (since it's extracted from machine)
            // Or we can display it as read-only info if needed.
            // The prompt says "extracted from machine data", implying it's derived.
            // But also says "Input Interface". Let's keep it visible but maybe read-only or just auto-updated.
            const SizedBox(height: 12),
            Text(
              "Tolerance:",
              style: TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: TextField(
                controller: toleranceController,
                style: const TextStyle(fontFamily: 'Segoe UI', fontSize: 14),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8, // Center vertically
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _notifyParent(),
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
            _buildHeader(
              "Sort Configuration",
              Icons.swap_vert,
              accentColor,
            ), // Sort icon

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
    const accentColor = Color(0xFF4ECDC4); // Turquoise

    return _buildGlassContainer(
      accentColor: accentColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Processing Options", Icons.settings, accentColor),

            _buildRadioButton(
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
            _buildRadioButton(
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
    bool isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? activeColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: activeColor,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Segoe UI',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
