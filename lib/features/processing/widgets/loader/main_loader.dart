import 'package:flutter/material.dart';

/// الدائرة المتحركة الرئيسية
class MainLoader extends StatefulWidget {
  const MainLoader({super.key});

  @override
  State<MainLoader> createState() => _MainLoaderState();
}

class _MainLoaderState extends State<MainLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
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
        return Transform.scale(
          scale: 1.0 + (0.1 * (0.5 - (_controller.value - 0.5).abs())),
          child: Container(
            width: 96, // w-24
            height: 96, // h-24
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3B82F6), // blue-500
                  Color(0xFF2563EB), // blue-600
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromRGBO(37, 99, 235, 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: RotationTransition(
              turns: _controller,
              child: const Icon(
                Icons.cached,
                size: 48, // w-12 h-12
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
