import 'package:flutter/material.dart';

/// Performance Indicator - مؤشر الأداء
class PerformanceIndicator extends StatelessWidget {
  final double efficiency;

  const PerformanceIndicator({super.key, required this.efficiency});

  @override
  Widget build(BuildContext context) {
    String title;
    String description;
    List<Color> gradientColors;
    IconData icon;
    Color textColor;
    Color subTextColor;

    if (efficiency >= 90) {
      title = 'أداء ممتاز!';
      description = 'كفاءة استثنائية في استخدام المواد';
      gradientColors = [const Color(0xFF22C55E), const Color(0xFF16A34A)];
      icon = Icons.trending_up;
      textColor = Colors.white;
      subTextColor = const Color(0xFFDCFCE7);
    } else if (efficiency >= 80) {
      title = 'أداء جيد';
      description = 'يمكن تحسين النتائج قليلاً';
      gradientColors = [const Color(0xFF3B82F6), const Color(0xFF2563EB)];
      icon = Icons.thumb_up;
      textColor = Colors.white;
      subTextColor = const Color(0xFFDBEAFE);
    } else {
      title = 'بحاجة لتحسين';
      description = 'نسبة الهادر مرتفعة نسبياً';
      gradientColors = [const Color(0xFFF59E0B), const Color(0xFFD97706)];
      icon = Icons.warning;
      textColor = Colors.white;
      subTextColor = const Color(0xFFFEF3C7);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: subTextColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
