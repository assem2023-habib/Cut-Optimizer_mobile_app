import 'package:flutter/material.dart';

/// Back Button - زر الرجوع
class ProcessingBackButton extends StatefulWidget {
  final VoidCallback onTap;

  const ProcessingBackButton({super.key, required this.onTap});

  @override
  State<ProcessingBackButton> createState() => _ProcessingBackButtonState();
}

class _ProcessingBackButtonState extends State<ProcessingBackButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB), // gray-200
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward, // ArrowRight for RTL
                color: Color(0xFF374151), // gray-700
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'رجوع',
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Process Button - زر بدء المعالجة
class ProcessButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const ProcessButton({super.key, required this.enabled, required this.onTap});

  @override
  State<ProcessButton> createState() => _ProcessButtonState();
}

class _ProcessButtonState extends State<ProcessButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFD1D5DB), // gray-300
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'بدء المعالجة',
              style: TextStyle(
                color: Color(0xFF6B7280), // gray-500
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.play_arrow, color: Color(0xFF6B7280), size: 20),
          ],
        ),
      );
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xFF2563EB), // blue-600
                Color(0xFF1D4ED8), // blue-700
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'بدء المعالجة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.play_arrow, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
