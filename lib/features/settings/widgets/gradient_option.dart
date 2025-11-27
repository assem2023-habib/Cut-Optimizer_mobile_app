import 'package:flutter/material.dart';
import '../styles/settings_theme.dart';
import '../../../services/background_service.dart';

class GradientOption extends StatelessWidget {
  final BackgroundGradient gradient;
  final bool isSelected;
  final VoidCallback onTap;

  const GradientOption({
    super.key,
    required this.gradient,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient.colors,
          ),
          border: Border.all(
            color: isSelected ? SettingsTheme.neonGreen : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: isSelected
            ? Icon(Icons.check, color: Colors.white, size: 30)
            : null,
      ),
    );
  }
}
