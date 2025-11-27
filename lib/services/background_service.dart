import 'package:flutter/material.dart';
import 'dart:io';

class BackgroundService {
  // Preset gradient backgrounds
  static final List<BackgroundGradient> presetGradients = [
    BackgroundGradient(
      id: 'gradient_blue_purple',
      name: 'Blue Purple',
      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    ),
    BackgroundGradient(
      id: 'gradient_orange_pink',
      name: 'Orange Pink',
      colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    ),
    BackgroundGradient(
      id: 'gradient_green_blue',
      name: 'Green Blue',
      colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    ),
    BackgroundGradient(
      id: 'gradient_purple_blue',
      name: 'Purple Blue',
      colors: [Color(0xFF4e54c8), Color(0xFF8f94fb)],
    ),
    BackgroundGradient(
      id: 'gradient_pink_orange',
      name: 'Pink Orange',
      colors: [Color(0xFFfa709a), Color(0xFFfee140)],
    ),
    BackgroundGradient(
      id: 'gradient_dark_blue',
      name: 'Dark Blue',
      colors: [Color(0xFF0f2027), Color(0xFF2c5364)],
    ),
  ];

  static BackgroundGradient? getGradientById(String id) {
    try {
      return presetGradients.firstWhere((g) => g.id == id);
    } catch (e) {
      return presetGradients.first; // Default
    }
  }

  static BoxDecoration getBackgroundDecoration(String backgroundImage) {
    // Check if it's a gradient ID
    final gradient = getGradientById(backgroundImage);
    if (gradient != null) {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient.colors,
        ),
      );
    }

    // Otherwise, it's an image path (file)
    return BoxDecoration(
      image: DecorationImage(
        image: FileImage(File(backgroundImage)),
        fit: BoxFit.cover,
      ),
    );
  }
}

class BackgroundGradient {
  final String id;
  final String name;
  final List<Color> colors;

  BackgroundGradient({
    required this.id,
    required this.name,
    required this.colors,
  });
}
