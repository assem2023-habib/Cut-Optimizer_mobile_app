import 'package:flutter/material.dart';
import '../styles/settings_theme.dart';
import '../../../models/config.dart';

class MachineSizeCard extends StatelessWidget {
  final MachineSize machineSize;
  final VoidCallback onDelete;

  const MachineSizeCard({
    super.key,
    required this.machineSize,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: SettingsTheme.glassContainer(),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: SettingsTheme.buttonGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.straighten, color: Colors.white, size: 24),
          ),
          SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(machineSize.name, style: SettingsTheme.cardText),
                SizedBox(height: 4),
                Text(
                  '${machineSize.minWidth} - ${machineSize.maxWidth} cm',
                  style: SettingsTheme.cardSubtext,
                ),
              ],
            ),
          ),
          // Delete button
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              color: SettingsTheme.neonGreen,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
