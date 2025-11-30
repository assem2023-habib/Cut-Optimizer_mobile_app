import 'package:flutter/material.dart';

/// النقاط المتحركة
class AnimatedDots extends StatelessWidget {
  const AnimatedDots({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Dot(delay: 0),
        SizedBox(width: 8),
        _Dot(delay: 150),
        SizedBox(width: 8),
        _Dot(delay: 300),
      ],
    );
  }
}

/// نقطة متحركة واحدة
class _Dot extends StatefulWidget {
  final int delay;

  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
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
        return Transform.translate(
          offset: Offset(0, -12 * _controller.value),
          child: Container(
            width: 8, // w-2
            height: 8, // h-2
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB), // blue-600
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
