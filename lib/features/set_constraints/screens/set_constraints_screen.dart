import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/processing_config_section.dart';
import '../../sorting_options/screens/sorting_options_screen.dart';
import '../../../models/config.dart';

class SetConstraintsScreen extends StatefulWidget {
  final String filePath;
  final Config config;

  const SetConstraintsScreen({
    super.key,
    required this.filePath,
    required this.config,
  });

  @override
  State<SetConstraintsScreen> createState() => _SetConstraintsScreenState();
}

class _SetConstraintsScreenState extends State<SetConstraintsScreen> {
  final TextEditingController _maxWidthController = TextEditingController(
    text: "400",
  );
  final TextEditingController _minWidthController = TextEditingController(
    text: "50",
  );
  final TextEditingController _toleranceController = TextEditingController(
    text: "5",
  );

  MachineSize? _selectedMachine;

  @override
  void dispose() {
    _maxWidthController.dispose();
    _minWidthController.dispose();
    _toleranceController.dispose();
    super.dispose();
  }

  void _onMachineSelected(MachineSize? machine) {
    if (machine != null) {
      setState(() {
        _selectedMachine = machine;
        _minWidthController.text = machine.minWidth.toString();
        _maxWidthController.text = machine.maxWidth.toString();
      });
    }
  }

  void _navigateToNextScreen() {
    final maxWidth = int.tryParse(_maxWidthController.text) ?? 400;
    final minWidth = int.tryParse(_minWidthController.text) ?? 50;
    final tolerance = int.tryParse(_toleranceController.text) ?? 5;

    // Validate constraints
    if (minWidth >= maxWidth) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Minimum width must be less than maximum width"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SortingOptionsScreen(
          filePath: widget.filePath,
          minWidth: minWidth,
          maxWidth: maxWidth,
          tolerance: tolerance,
          config: widget.config,
        ),
      ),
    );
  }

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SET CONSTRAINTS",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 40),
                        const SizedBox(height: 20),
                        const ProcessingConfigSection(),
                        const SizedBox(height: 40),
                        /*
                        if (widget.config.machineSizes.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField<MachineSize>(
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Select Machine',
                                  contentPadding: EdgeInsets.zero,
                                ),
                                value: _selectedMachine,
                                items: widget.config.machineSizes.map((
                                  machine,
                                ) {
                                  return DropdownMenuItem<MachineSize>(
                                    value: machine,
                                    child: Text(
                                      "${machine.name} (${machine.minWidth}-${machine.maxWidth} cm)",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: _onMachineSelected,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                        CustomTextField(
                          label: "Max Width",
                          initialValue: "400",
                          suffixText: "cm",
                          controller: _maxWidthController,
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: "Min Width",
                          initialValue: "50",
                          suffixText: "cm",
                          controller: _minWidthController,
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: "Tolerance",
                          initialValue: "5",
                          suffixText: "cm",
                          controller: _toleranceController,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _navigateToNextScreen,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF0D47A1,
                              ), // Corporate Blue
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
                        const SizedBox(height: 24),
                        */
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
