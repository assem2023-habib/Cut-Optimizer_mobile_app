import 'package:flutter/material.dart';
import '../../../shared/layout/main_layout.dart';
import '../../../models/config.dart';
import '../widgets/loom_settings.dart';
import '../widgets/measurement_unit.dart';
import '../widgets/prep_codes.dart';
import '../widgets/action_buttons.dart';
import '../widgets/info_box.dart';
import '../../../core/services/config_service.dart';

/// شاشة الإعدادات (Settings Screen) - التصميم الجديد
/// 4 أقسام: إعدادات النول + وحدة القياس + أكواد التحضير + أزرار الإجراءات
class SettingsScreen extends StatefulWidget {
  final Config config;

  const SettingsScreen({super.key, required this.config});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Config _config;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  void _resetSettings() {
    setState(() {
      _config = Config.defaultConfig();
    });
    ConfigService.instance.saveConfig(_config);
  }

  void _saveSettings() async {
    final success = await ConfigService.instance.saveConfig(_config);

    if (mounted) {
      setState(() {
        _isSaved = success;
      });

      // Reset saved state after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isSaved = false;
          });
        }
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ الإعدادات بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء حفظ الإعدادات'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentPage: 'settings',
      showBottomNav: true,
      hasProcessedData: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // العنوان
            const Text(
              'الإعدادات',
              style: TextStyle(
                color: Color(0xFF1F2937), // gray-800
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'قم بتخصيص إعدادات التطبيق حسب احتياجاتك',
              style: TextStyle(
                color: Color(0xFF4B5563), // gray-600
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

            // 1. إعدادات النول
            LoomSettings(
              machineSizes: _config.machineSizes,
              onUpdate: (updatedSizes) {
                setState(() {
                  _config.machineSizes = updatedSizes;
                });
              },
            ),

            const SizedBox(height: 24),

            // 2. وحدة القياس
            MeasurementUnitWidget(
              selectedUnit: _config.measurementUnit,
              onUnitChanged: (unit) {
                setState(() {
                  _config.measurementUnit = unit;
                });
              },
            ),

            const SizedBox(height: 24),

            // 3. أكواد التحضير
            const PrepCodes(),

            const SizedBox(height: 24),

            // 4. أزرار الإجراءات
            ActionButtons(
              isSaved: _isSaved,
              onReset: _resetSettings,
              onSave: _saveSettings,
            ),

            const SizedBox(height: 16),

            // Info Box
            const SettingsInfoBox(),
          ],
        ),
      ),
    );
  }
}
