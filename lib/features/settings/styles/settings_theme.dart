import 'package:flutter/material.dart';
import 'dart:ui';

class SettingsTheme {
  // Colors
  static const Color neonGreen = Color(0xFF00FF91);
  static const Color darkGlass = Color(0xAA000000); // Translucent black
  static const Color lightGlass = Color(0x10FFFFFF); // Low opacity white
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFFAAAAAA);
  static const Color darkBackground = Color(0xFF1E1E1E);

  // Text Styles
  static const TextStyle settingsTitle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textWhite,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textWhite,
  );

  static const TextStyle cardText = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textWhite,
  );

  static const TextStyle cardSubtext = TextStyle(
    fontFamily: 'Segoe UI',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textGrey,
  );

  // Gradients
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF00FF91), Color(0xFF00B4D8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glass Container Decoration
  static BoxDecoration glassContainer({double blur = 10.0}) {
    return BoxDecoration(
      color: lightGlass,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
    );
  }

  // Group Box Decoration (Dark Grey Border, Rounded Corners)
  static BoxDecoration groupBoxDecoration() {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFF3A3A3A), width: 1.5),
    );
  }

  // Dark Glass Background
  static BoxDecoration darkGlassBackground() {
    return BoxDecoration(color: darkBackground);
  }
}
