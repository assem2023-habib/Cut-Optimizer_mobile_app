import 'package:flutter/material.dart';
import '../../../models/config.dart';
import '../../../services/background_service.dart';
import '../styles/settings_theme.dart';
import 'glass_container.dart';

class AppearanceSettingsWidget extends StatelessWidget {
  final Config config;
  final ValueChanged<BackgroundType> onTypeChanged;
  final ValueChanged<String> onGradientChanged;
  final VoidCallback onImageUpload;

  const AppearanceSettingsWidget({
    super.key,
    required this.config,
    required this.onTypeChanged,
    required this.onGradientChanged,
    required this.onImageUpload,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('🎨', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text('Appearance', style: SettingsTheme.sectionTitle),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Customize the application appearance according to your preferences',
            style: SettingsTheme.cardSubtext.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Radio Buttons
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _buildRadioOption(BackgroundType.image, 'Background Image'),
              _buildRadioOption(BackgroundType.gradient, 'Color Gradient'),
            ],
          ),
          const SizedBox(height: 16),

          // Controls
          if (config.backgroundType == BackgroundType.image)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onImageUpload,
                icon: const Icon(Icons.folder_open, color: Colors.white),
                label: const Text('Change Background'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D5F8D), // Blue as requested
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: config.backgroundImage.startsWith('gradient_')
                      ? config.backgroundImage
                      : 'gradient_blue_purple', // Default fallback
                  isExpanded: true,
                  dropdownColor: const Color(0xFF2A2A2A),
                  style: SettingsTheme.cardText,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  items: BackgroundService.presetGradients.map((gradient) {
                    return DropdownMenuItem<String>(
                      value: gradient.id,
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradient.colors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(gradient.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onGradientChanged(value);
                    }
                  },
                ),
              ),
            ),

          const SizedBox(height: 12),
          // Hint
          Row(
            children: [
              const Text('💡 ', style: TextStyle(fontSize: 14)),
              Expanded(
                child: Text(
                  'Tip: Choose a background style that relaxes your eyes',
                  style: SettingsTheme.cardSubtext.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioOption(BackgroundType type, String label) {
    final isSelected = config.backgroundType == type;
    return GestureDetector(
      onTap: () => onTypeChanged(type),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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
          Flexible(
            child: Text(
              label,
              style: SettingsTheme.cardText.copyWith(
                color: isSelected
                    ? SettingsTheme.neonGreen
                    : SettingsTheme.textWhite,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
