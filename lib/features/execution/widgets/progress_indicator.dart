import 'package:flutter/material.dart';

/// Progress Indicator Widget
/// مؤشر التقدم الدائري مع النسبة المئوية
class ExecutionProgressIndicator extends StatelessWidget {
  final double progress;

  const ExecutionProgressIndicator({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 12,
            backgroundColor: Colors.blue.shade50,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
          ),
          Center(
            child: Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
