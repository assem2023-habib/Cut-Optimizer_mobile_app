import 'package:flutter/material.dart';
import '../../../models/config.dart';
import '../styles/settings_theme.dart';
import '../../../utils/background_color_helper.dart';
import 'glass_container.dart';

class MachineSizesWidget extends StatelessWidget {
  final Config config;
  final VoidCallback onAdd;
  final Function(int) onDelete;
  final VoidCallback onUpdate;

  const MachineSizesWidget({
    super.key,
    required this.config,
    required this.onAdd,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = BackgroundColorHelper.getTextColorFromConfig(config);

    return GlassContainer(
      textColor: textColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              const Text('📏', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                'Machine Sizes',
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

          // Table
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(
                  Colors.white.withOpacity(0.05),
                ),
                dataRowColor: MaterialStateProperty.all(Colors.transparent),
                columnSpacing: 20,
                columns: [
                  DataColumn(
                    label: Text('Name', style: SettingsTheme.cardText),
                  ),
                  DataColumn(
                    label: Text('Min Width', style: SettingsTheme.cardText),
                  ),
                  DataColumn(
                    label: Text('Max Width', style: SettingsTheme.cardText),
                  ),
                  DataColumn(
                    label: Text('Tolerance', style: SettingsTheme.cardText),
                  ),
                  DataColumn(
                    label: Text('', style: SettingsTheme.cardText),
                  ), // Actions
                ],
                rows: config.machineSizes.asMap().entries.map((entry) {
                  final index = entry.key;
                  final size = entry.value;
                  return DataRow(
                    cells: [
                      DataCell(Text(size.name, style: SettingsTheme.cardText)),
                      DataCell(
                        Text('${size.minWidth}', style: SettingsTheme.cardText),
                      ),
                      DataCell(
                        Text('${size.maxWidth}', style: SettingsTheme.cardText),
                      ),
                      DataCell(
                        Text(
                          '${size.tolerance}',
                          style: SettingsTheme.cardText,
                        ),
                      ),
                      DataCell(
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Color(0xFFD32F2F),
                          ),
                          onPressed: () =>
                              _showDeleteConfirmation(context, index),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Add New Size'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32), // Green
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onUpdate,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Update'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2), // Blue
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Confirm Deletion',
          style: SettingsTheme.sectionTitle,
        ),
        content: const Text(
          'Are you sure you want to delete this machine size?',
          style: SettingsTheme.cardText,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: SettingsTheme.textGrey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete(index);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
  }
}
