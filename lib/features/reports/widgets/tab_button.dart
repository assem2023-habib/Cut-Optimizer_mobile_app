import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String label;
  final int count;
  final bool isActive;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.label,
    required this.count,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFEFF6FF) : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? const Color(0xFF1D4ED8)
                      : const Color(0xFF4B5563),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '($count)',
                style: TextStyle(
                  color: isActive
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF6B7280),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
