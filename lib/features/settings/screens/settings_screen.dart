import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../styles/settings_theme.dart';
import '../widgets/appearance_settings_widget.dart';
import '../widgets/machine_sizes_widget.dart';
import '../widgets/measurement_settings_widget.dart';
import '../widgets/add_machine_size_dialog.dart';
import '../../../models/config.dart';
import '../../../services/config_service.dart';
import '../../../services/background_service.dart';

class SettingsScreen extends StatefulWidget {
  final Config config;

  const SettingsScreen({super.key, required this.config});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Config _config;
  final ConfigService _configService = ConfigService();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  Future<void> _saveConfig() async {
    try {
      await _configService.saveConfig(_config);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving settings: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateConfig() {
    _saveConfig();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings updated successfully!'),
          backgroundColor: SettingsTheme.neonGreen,
        ),
      );
    }
  }

  void _onBackgroundTypeChanged(BackgroundType type) {
    setState(() {
      _config.backgroundType = type;
      if (type == BackgroundType.gradient &&
          !_config.backgroundImage.startsWith('gradient_')) {
        _config.backgroundImage = 'gradient_blue_purple';
      }
    });
    _saveConfig();
  }

  void _onGradientChanged(String gradientId) {
    setState(() {
      _config.backgroundImage = gradientId;
      _config.backgroundType = BackgroundType.gradient;
    });
    _saveConfig();
  }

  Future<void> _onImageUpload() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        final fileName =
            'background_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
        final savedPath = '${directory.path}/$fileName';

        await File(image.path).copy(savedPath);
        await BackgroundService.deleteOldBackgroundImages(savedPath);

        setState(() {
          _config.backgroundImage = savedPath;
          _config.backgroundType = BackgroundType.image;
        });
        _saveConfig();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Background image uploaded!'),
              backgroundColor: SettingsTheme.neonGreen,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _onAddMachineSize() async {
    final result = await showDialog<MachineSize>(
      context: context,
      builder: (context) => const AddMachineSizeDialog(),
    );

    if (result != null) {
      setState(() {
        _config.machineSizes.add(result);
      });
      _saveConfig();
    }
  }

  void _onDeleteMachineSize(int index) {
    setState(() {
      _config.machineSizes.removeAt(index);
    });
    _saveConfig();
  }

  void _onUnitChanged(MeasurementUnit unit) {
    setState(() {
      _config.measurementUnit = unit;
    });
    _saveConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BackgroundService.getBackgroundDecoration(
          _config.backgroundImage,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      AppearanceSettingsWidget(
                        config: _config,
                        onTypeChanged: _onBackgroundTypeChanged,
                        onGradientChanged: _onGradientChanged,
                        onImageUpload: _onImageUpload,
                      ),
                      const SizedBox(height: 20),
                      MachineSizesWidget(
                        config: _config,
                        onAdd: _onAddMachineSize,
                        onDelete: _onDeleteMachineSize,
                        onUpdate: _updateConfig,
                      ),
                      const SizedBox(height: 20),
                      MeasurementSettingsWidget(
                        config: _config,
                        onUnitChanged: _onUnitChanged,
                      ),
                      const SizedBox(height: 20),
                      // Close Button (Bottom Action)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).pop(_config),
                          icon: const Icon(Icons.close, color: Colors.white),
                          label: const Text('Close'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFD32F2F,
                            ), // Dark Red
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      alignment: Alignment.center,
      child: const Text(
        '⚙️ Application Settings',
        style: SettingsTheme.settingsTitle,
      ),
    );
  }
}
