import 'package:flutter/material.dart';
import '../services/background_service.dart';
import '../models/config.dart';

class BackgroundColorHelper {
  /// Calculate luminance of a color (0.0 = black, 1.0 = white)
  static double calculateLuminance(Color color) {
    return color.computeLuminance();
  }

  /// Calculate average luminance of a gradient
  static double calculateGradientLuminance(List<Color> colors) {
    if (colors.isEmpty) return 0.5;

    double totalLuminance = 0;
    for (var color in colors) {
      totalLuminance += calculateLuminance(color);
    }
    return totalLuminance / colors.length;
  }

  /// Determine if a gradient is dark (returns true if dark, false if light)
  static bool isGradientDark(List<Color> colors) {
    double avgLuminance = calculateGradientLuminance(colors);
    // Threshold at 0.5 - below is dark, above is light
    return avgLuminance < 0.5;
  }

  /// Get appropriate text color based on background gradient ID
  static Color getTextColorForBackground(String backgroundImage) {
    // If it's a gradient
    if (backgroundImage.startsWith('gradient_')) {
      // Find the gradient in presets
      final gradient = BackgroundService.presetGradients.firstWhere(
        (g) => g.id == backgroundImage,
        orElse: () => BackgroundService.presetGradients.first,
      );

      bool isDark = isGradientDark(gradient.colors);
      return isDark ? Colors.white : const Color(0xFF1A1A1A);
    }

    // For custom images, default to white (most images tend to be darker)
    return Colors.white;
  }

  /// Get secondary text color (for subtitles, hints, etc.)
  static Color getSecondaryTextColorForBackground(String backgroundImage) {
    if (backgroundImage.startsWith('gradient_')) {
      final gradient = BackgroundService.presetGradients.firstWhere(
        (g) => g.id == backgroundImage,
        orElse: () => BackgroundService.presetGradients.first,
      );

      bool isDark = isGradientDark(gradient.colors);
      return isDark ? Colors.white.withOpacity(0.7) : const Color(0xFF555555);
    }

    return Colors.white.withOpacity(0.7);
  }

  /// Get text color directly from Config object
  static Color getTextColorFromConfig(Config config) {
    return getTextColorForBackground(config.backgroundImage);
  }

  /// Get secondary text color directly from Config object
  static Color getSecondaryTextColorFromConfig(Config config) {
    return getSecondaryTextColorForBackground(config.backgroundImage);
  }
}
