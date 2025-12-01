import 'package:flutter/material.dart';
import '../../../models/config.dart';
import '../../../services/background_service.dart';
import '../styles/settings_theme.dart';
import '../../../utils/background_color_helper.dart';
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
    final textColor = BackgroundColorHelper.getTextColorFromConfig(config);
    final secondaryTextColor =
        BackgroundColorHelper.getSecondaryTextColorFromConfig(config);

    return GlassContainer(
      textColor: textColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('🎨', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(
                    'Appearance',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Customize the application appearance according to your preferences',
            style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 12,
              color: secondaryTextColor,
            ),
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
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: BackgroundService.presetGradients.length,
              itemBuilder: (context, index) {
                final gradient = BackgroundService.presetGradients[index];
                final isSelected = config.backgroundImage == gradient.id;

                return GestureDetector(
                  onTap: () => onGradientChanged(gradient.id),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient.colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: gradient.colors.first.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              },
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
