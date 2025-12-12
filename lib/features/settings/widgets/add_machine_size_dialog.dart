import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/settings_theme.dart';
import '../../../models/config.dart';
import 'dart:ui';

class AddMachineSizeDialog extends StatefulWidget {
  const AddMachineSizeDialog({super.key});

  @override
  State<AddMachineSizeDialog> createState() => _AddMachineSizeDialogState();
}

class _AddMachineSizeDialogState extends State<AddMachineSizeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _minWidthController = TextEditingController();
  final _maxWidthController = TextEditingController();
  final _toleranceController = TextEditingController();
  final _pathLengthController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _minWidthController.dispose();
    _maxWidthController.dispose();
    _toleranceController.dispose();
    _pathLengthController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_formKey.currentState!.validate()) {
      final machineSize = MachineSize(
        name: _nameController.text,
        minWidth: int.parse(_minWidthController.text),
        maxWidth: int.parse(_maxWidthController.text),
        tolerance: int.parse(_toleranceController.text),
        pathLength: int.parse(_pathLengthController.text),
      );
      Navigator.of(context).pop(machineSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: SettingsTheme.darkGlass,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                    'Add Machine Size',
                    style: SettingsTheme.settingsTitle.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Name field
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    hint: 'e.g., Small',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  // Min width field
                  _buildTextField(
                    controller: _minWidthController,
                    label: 'Min Width (cm)',
                    hint: 'e.g., 50',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter min width';
                      }
                      final num = int.tryParse(value);
                      if (num == null || num <= 0) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  // Max width field
                  _buildTextField(
                    controller: _maxWidthController,
                    label: 'Max Width (cm)',
                    hint: 'e.g., 200',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter max width';
                      }
                      final num = int.tryParse(value);
                      if (num == null || num <= 0) {
                        return 'Please enter a valid number';
                      }
                      final minNum = int.tryParse(_minWidthController.text);
                      if (minNum != null && num <= minNum) {
                        return 'Max must be greater than min';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  // Tolerance field
                  _buildTextField(
                    controller: _toleranceController,
                    label: 'Tolerance (cm)',
                    hint: 'e.g., 10',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter tolerance';
                      }
                      final num = int.tryParse(value);
                      if (num == null || num <= 0) {
                        return 'Tolerance must be > 0';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 12),
                  // Path Length field
                  _buildTextField(
                    controller: _pathLengthController,
                    label: 'Path Length (cm)',
                    hint: 'e.g., 100',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter path length';
                      }
                      final num = int.tryParse(value);
                      if (num == null || num <= 0) {
                        return 'Path length must be > 0';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: SettingsTheme.textWhite,
                            side: BorderSide(color: SettingsTheme.textGrey),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Cancel', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: SettingsTheme.buttonGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: _handleAdd,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: SettingsTheme.cardText.copyWith(fontSize: 14)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: SettingsTheme.cardText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: SettingsTheme.cardSubtext,
            filled: true,
            fillColor: SettingsTheme.lightGlass,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: SettingsTheme.neonGreen, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
