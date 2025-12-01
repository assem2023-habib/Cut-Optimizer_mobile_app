import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
    // ✨ NEW Beautiful Gradients
    BackgroundGradient(
      id: 'gradient_clean_white',
      name: 'Clean White',
      colors: [Colors.white, Colors.white, Color(0xFFE0F2F1)],
    ),
    BackgroundGradient(
      id: 'gradient_sunset',
      name: 'Sunset Glow',
      colors: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    ),
    BackgroundGradient(
      id: 'gradient_ocean',
      name: 'Deep Ocean',
      colors: [Color(0xFF667eea), Color(0xFF00F5FF)],
    ),
    BackgroundGradient(
      id: 'gradient_forest',
      name: 'Forest Dream',
      colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
    ),
    BackgroundGradient(
      id: 'gradient_purple_night',
      name: 'Purple Night',
      colors: [Color(0xFF360033), Color(0xFF0b8793)],
    ),
    BackgroundGradient(
      id: 'gradient_fire',
      name: 'Fire Blaze',
      colors: [Color(0xFFf12711), Color(0xFFf5af19)],
    ),
    BackgroundGradient(
      id: 'gradient_northern_lights',
      name: 'Northern Lights',
      colors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
    ),
    BackgroundGradient(
      id: 'gradient_royal',
      name: 'Royal Purple',
      colors: [Color(0xFF141E30), Color(0xFF243B55)],
    ),
    BackgroundGradient(
      id: 'gradient_cherry',
      name: 'Cherry Blossom',
      colors: [Color(0xFFEB3349), Color(0xFFF45C43)],
    ),
    BackgroundGradient(
      id: 'gradient_mint',
      name: 'Fresh Mint',
      colors: [Color(0xFF00b09b), Color(0xFF96c93d)],
    ),
    BackgroundGradient(
      id: 'gradient_cosmic',
      name: 'Cosmic Purple',
      colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
    ),
    BackgroundGradient(
      id: 'gradient_peach',
      name: 'Peach Sunset',
      colors: [Color(0xFFFFECD2), Color(0xFFFCB69F)],
    ),
    BackgroundGradient(
      id: 'gradient_emerald',
      name: 'Emerald Water',
      colors: [Color(0xFF348F50), Color(0xFF56B4D3)],
    ),
    BackgroundGradient(
      id: 'gradient_aurora',
      name: 'Aurora Sky',
      colors: [Color(0xFF00d2ff), Color(0xFF928DAB)],
    ),
    BackgroundGradient(
      id: 'gradient_lavender',
      name: 'Lavender Dream',
      colors: [Color(0xFFD3959B), Color(0xFFBFE6BA)],
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

  static Future<void> deleteOldBackgroundImages(String currentImagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory(directory.path);

      // List all files in the directory
      final files = dir.listSync();

      for (var file in files) {
        if (file is File) {
          final fileName = file.path.split(Platform.pathSeparator).last;
          // Check if it's a background image file and not the current one
          if (fileName.startsWith('background_') &&
              (fileName.endsWith('.jpg') ||
                  fileName.endsWith('.jpeg') ||
                  fileName.endsWith('.png')) &&
              file.path != currentImagePath) {
            await file.delete();
            print('Deleted old background: ${file.path}');
          }
        }
      }
    } catch (e) {
      print('Error deleting old background images: $e');
    }
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
