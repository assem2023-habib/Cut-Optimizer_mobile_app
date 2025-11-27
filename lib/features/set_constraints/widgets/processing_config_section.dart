import 'package:flutter/material.dart';

class ProcessingConfigSection extends StatefulWidget {
  const ProcessingConfigSection({super.key});

  @override
  State<ProcessingConfigSection> createState() =>
      _ProcessingConfigSectionState();
}

class _ProcessingConfigSectionState extends State<ProcessingConfigSection> {
  // State for Panel A
  final List<Map<String, dynamic>> machineSizes = [
    {'name': 'Small', 'min': 300, 'max': 400},
    {'name': 'Medium', 'min': 400, 'max': 600},
    {'name': 'Large', 'min': 600, 'max': 800},
  ];
  Map<String, dynamic>? selectedMachineSize;
  final TextEditingController toleranceController = TextEditingController(
    text: "5",
  );

  // State for Panel B
  String sortOption = "Height";

  // State for Panel C
  String processingOption = "No Main Repeat";

  @override
  void initState() {
    super.initState();
    // Default selection for Panel A
    if (machineSizes.isNotEmpty) {
      selectedMachineSize = machineSizes[0];
    }
  }

  @override
  void dispose() {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            child, // BackdropFilter could be added here if performance allows
      ),
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
                child: DropdownButton<Map<String, dynamic>>(
                  value: selectedMachineSize,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: accentColor),
                  items: machineSizes.map((size) {
                    return DropdownMenuItem<Map<String, dynamic>>(
                      value: size,
                      child: Text(
                        "${size['name']} (${size['min']}-${size['max']})",
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

            _buildRadioButton(
              "Width",
              sortOption,
              (val) => setState(() => sortOption = val!),
              accentColor,
            ),
            _buildRadioButton(
              "Quantity",
              sortOption,
              (val) => setState(() => sortOption = val!),
              accentColor,
            ),
            _buildRadioButton(
              "Height",
              sortOption,
              (val) => setState(() => sortOption = val!),
              accentColor,
            ),
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
                processingOption,
                (val) => setState(() => processingOption = val!),
                accentColor,
              ),
            ),
            Tooltip(
              message: "Avoid repeating the main pattern",
              child: _buildRadioButton(
                "No Main Repeat",
                processingOption,
                (val) => setState(() => processingOption = val!),
                accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(
    String value,
    String groupValue,
    ValueChanged<String?> onChanged,
    Color activeColor,
  ) {
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: activeColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(fontFamily: 'Segoe UI', fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
