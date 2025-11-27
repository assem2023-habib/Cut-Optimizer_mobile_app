import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../styles/settings_theme.dart';
import '../widgets/gradient_option.dart';
import '../widgets/machine_size_card.dart';
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

  void _selectGradient(String gradientId) {
    setState(() {
      _config.backgroundImage = gradientId;
    });
    _saveConfig();
  }

  Future<void> _addMachineSize() async {
    final result = await showDialog<MachineSize>(
      context: context,
      builder: (context) => AddMachineSizeDialog(),
    );

    if (result != null) {
      setState(() {
        _config.machineSizes.add(result);
      });
      _saveConfig();
    }
  }

  void _deleteMachineSize(int index) {
    setState(() {
      _config.machineSizes.removeAt(index);
    });
    _saveConfig();
  }

  Future<void> _uploadImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        // Copy image to app directory
        final directory = await getApplicationDocumentsDirectory();
        final fileName =
            'background_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
        final savedPath = '${directory.path}/$fileName';

        await File(image.path).copy(savedPath);

        setState(() {
          _config.backgroundImage = savedPath;
        });
        _saveConfig();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: SettingsTheme.darkGlassBackground(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAppearanceSection(),
                        SizedBox(height: 32),
                        _buildMachineSizesSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Settings', style: SettingsTheme.settingsTitle),
          IconButton(
            onPressed: () => Navigator.of(context).pop(_config),
            icon: Icon(Icons.close, color: SettingsTheme.textWhite, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            Icon(
              Icons.palette_outlined,
              color: SettingsTheme.neonGreen,
              size: 24,
            ),
            SizedBox(width: 8),
            Text('Appearance', style: SettingsTheme.sectionTitle),
          ],
        ),
        SizedBox(height: 16),
        // Subsection title
        Text(
          'Choose Background',
          style: SettingsTheme.cardText.copyWith(fontSize: 14),
        ),
        SizedBox(height: 12),
        // Gradient options
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: BackgroundService.presetGradients.map((gradient) {
              return GradientOption(
                gradient: gradient,
                isSelected: _config.backgroundImage == gradient.id,
                onTap: () => _selectGradient(gradient.id),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
        // Upload image button
        GestureDetector(
          onTap: _uploadImage,
          child: Container(
            height: 120,
            width: 120,
            decoration: SettingsTheme.glassContainer(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  color: SettingsTheme.neonGreen,
                  size: 40,
                ),
                SizedBox(height: 8),
                Text(
                  'Upload\nImage',
                  textAlign: TextAlign.center,
                  style: SettingsTheme.cardText.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMachineSizesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Row(
          children: [
            Icon(
              Icons.settings_outlined,
              color: SettingsTheme.neonGreen,
              size: 24,
            ),
            SizedBox(width: 8),
            Text('Machine Sizes', style: SettingsTheme.sectionTitle),
          ],
        ),
        SizedBox(height: 16),
        // Machine size cards
        if (_config.machineSizes.isEmpty)
          Container(
            padding: EdgeInsets.all(24),
            decoration: SettingsTheme.glassContainer(),
            child: Center(
              child: Text(
                'No machine sizes added yet',
                style: SettingsTheme.cardSubtext,
              ),
            ),
          )
        else
          ..._config.machineSizes.asMap().entries.map((entry) {
            return MachineSizeCard(
              machineSize: entry.value,
              onDelete: () => _deleteMachineSize(entry.key),
            );
          }).toList(),
        SizedBox(height: 16),
        // Add button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: Container(
            decoration: BoxDecoration(
              gradient: SettingsTheme.buttonGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: _addMachineSize,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Add Machine Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
