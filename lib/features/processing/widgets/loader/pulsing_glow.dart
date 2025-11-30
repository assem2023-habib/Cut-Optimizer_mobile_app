import 'package:flutter/material.dart';

/// التوهج الخلفي المتحرك
class PulsingGlow extends StatefulWidget {
  const PulsingGlow({super.key});

  @override
  State<PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<PulsingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: 0.3 + (0.2 * _controller.value),
          child: Container(
            width: 96 + (48 * _controller.value),
            height: 96 + (48 * _controller.value),
            decoration: BoxDecoration(
              color: const Color(0xFF60A5FA), // blue-400
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(96, 165, 250, 0.5),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
