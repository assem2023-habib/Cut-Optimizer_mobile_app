import 'package:flutter/material.dart';
import '../../../models/config.dart';
import '../styles/settings_theme.dart';
import '../../../utils/background_color_helper.dart';
import 'glass_container.dart';

class MeasurementSettingsWidget extends StatelessWidget {
  final Config config;
  final ValueChanged<MeasurementUnit> onUnitChanged;

  const MeasurementSettingsWidget({
    super.key,
    required this.config,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = BackgroundColorHelper.getTextColorFromConfig(config);

    return GlassContainer(
      textColor: textColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📏', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Measurement Unit',
                style: TextStyle(
                  fontFamily: 'Segoe UI',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildRadioOption(MeasurementUnit.m2, 'm²'),
              const SizedBox(width: 16),
              _buildRadioOption(MeasurementUnit.m, 'm'),
              const SizedBox(width: 16),
              _buildRadioOption(MeasurementUnit.cm, 'cm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(MeasurementUnit unit, String label) {
    final isSelected = config.measurementUnit == unit;
    return GestureDetector(
      onTap: () => onUnitChanged(unit),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected
                ? SettingsTheme.neonGreen
                : SettingsTheme.textGrey,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: SettingsTheme.cardText.copyWith(
              color: isSelected
                  ? SettingsTheme.neonGreen
                  : SettingsTheme.textWhite,
            ),
          ),
        ],
      ),
    );
  }
}
