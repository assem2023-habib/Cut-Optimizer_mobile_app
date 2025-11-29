import 'package:flutter/material.dart';

/// شاشة التحميل أثناء المعالجة (Processing Loader)
/// تعرض رسوم متحركة أثناء معالجة البيانات
class ProcessingLoaderScreen extends StatelessWidget {
  const ProcessingLoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // background
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الدائرة المتحركة الرئيسية مع التوهج
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // التوهج الخلفي
                      _PulsingGlow(),

                      // الدائرة الرئيسية
                      _MainLoader(),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // النص الرئيسي
                  const Text(
                    'جاري المعالجة...',
                    style: TextStyle(
                      color: Color(0xFF1F2937), // gray-800
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // الوصف
                  const Text(
                    'يتم الآن تحليل البيانات وتحسين القصات',
                    style: TextStyle(
                      color: Color(0xFF4B5563), // gray-600
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // النقاط المتحركة
                  const _AnimatedDots(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// الدائرة المتحركة الرئيسية
class _MainLoader extends StatefulWidget {
  const _MainLoader();

  @override
  State<_MainLoader> createState() => _MainLoaderState();
}

class _MainLoaderState extends State<_MainLoader>
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
                  color: const Color(0xFF2563EB).withOpacity(0.3),
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

/// التوهج الخلفي المتحرك
class _PulsingGlow extends StatefulWidget {
  const _PulsingGlow();

  @override
  State<_PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<_PulsingGlow>
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
                  color: const Color(0xFF60A5FA).withOpacity(0.5),
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

/// النقاط المتحركة
class _AnimatedDots extends StatelessWidget {
  const _AnimatedDots();

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
