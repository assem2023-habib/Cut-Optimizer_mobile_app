import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// الإجراءات السريعة في الصفحة الرئيسية
class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الإجراءات السريعة',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // شبكة الإجراءات
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _QuickActionCard(
              icon: Icons.upload_file,
              title: 'رفع ملف',
              subtitle: 'ابدأ معالجة جديدة',
              color: AppColors.primary600,
              onTap: () => Navigator.of(context).pushNamed('/upload'),
            ),
            _QuickActionCard(
              icon: Icons.settings,
              title: 'الإعدادات',
              subtitle: 'تخصيص التطبيق',
              color: const Color(0xFF6366F1), // Indigo
              onTap: () => Navigator.of(context).pushNamed('/settings'),
            ),
            _QuickActionCard(
              icon: Icons.description,
              title: 'التقارير',
              subtitle: 'عرض النتائج السابقة',
              color: const Color(0xFF10B981), // Green
              onTap: () {
                // TODO: Check if has processed data
                Navigator.of(context).pushNamed('/reports');
              },
            ),
            _QuickActionCard(
              icon: Icons.bar_chart,
              title: 'الإحصائيات',
              subtitle: 'تحليل البيانات',
              color: const Color(0xFFF59E0B), // Amber
              onTap: () {
                // TODO: Check if has processed data
                Navigator.of(context).pushNamed('/statistics');
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// بطاقة إجراء سريع واحد
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.gray600.withOpacity(0.7),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
