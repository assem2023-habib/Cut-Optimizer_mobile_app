import 'package:flutter/material.dart';
import '../../../models/config.dart';

/// Selected Loom Details - تفاصيل النول المختار
class SelectedLoomDetails extends StatelessWidget {
  final MachineSize loom;

  const SelectedLoomDetails({super.key, required this.loom});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF), // blue-50
        border: Border.all(color: const Color(0xFFBFDBFE)), // blue-200
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'تفاصيل النول المختار',
            style: TextStyle(
              color: Color(0xFF1E40AF), // blue-800
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _DetailCell(
                  label: 'الحد الأدنى',
                  value: '${loom.minWidth} سم',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailCell(
                  label: 'الحد الأقصى',
                  value: '${loom.maxWidth} سم',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DetailCell(
                  label: 'السماحية',
                  value: '${loom.tolerance} سم',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String value;

  const _DetailCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF2563EB), // blue-600
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E40AF), // blue-800
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
