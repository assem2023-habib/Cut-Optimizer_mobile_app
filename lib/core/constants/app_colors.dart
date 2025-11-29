import 'package:flutter/material.dart';

/// نظام الألوان الخاص بالتطبيق
/// جميع الألوان محددة بدقة حسب التصميم المطلوب
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ========== Primary Colors (Header & Active Navigation) ==========

  /// اللون الأساسي الفاتح - يستخدم في Header والأزرار النشطة
  /// #2563EB (RGB: 37, 99, 235) (HSL: 217°, 83%, 53%)
  static const Color primary600 = Color(0xFF2563EB);

  /// اللون الأساسي الغامق - يستخدم في نهاية تدرج Header
  /// #1D4ED8 (RGB: 29, 78, 216) (HSL: 217°, 76%, 48%)
  static const Color primary700 = Color(0xFF1D4ED8);

  // ========== Background Colors ==========

  /// خلفية التطبيق الرئيسية - رمادي فاتح جداً
  /// #F9FAFB (RGB: 249, 250, 251) (HSL: 210°, 20%, 98%)
  static const Color background = Color(0xFFF9FAFB);

  // ========== Gray Scale ==========

  /// رمادي فاتح - للحدود والخطوط الفاصلة
  /// #E5E7EB (RGB: 229, 231, 235) (HSL: 214°, 10%, 91%)
  static const Color gray200 = Color(0xFFE5E7EB);

  /// رمادي متوسط - للنصوص غير النشطة والأيقونات
  /// #4B5563 (RGB: 75, 85, 99) (HSL: 215°, 14%, 34%)
  static const Color gray600 = Color(0xFF4B5563);

  // ========== White ==========

  /// أبيض نقي - للنصوص على الخلفيات الداكنة والخلفيات البيضاء
  /// #FFFFFF (RGB: 255, 255, 255)
  static const Color white = Color(0xFFFFFFFF);

  // ========== Gradients ==========

  /// تدرج Header - من اليمين لليسار (RTL)
  /// يبدأ بـ primary600 وينتهي بـ primary700
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.centerRight, // RTL: من اليمين
    end: Alignment.centerLeft, // إلى اليسار
    colors: [primary600, primary700],
  );

  // ========== Status Colors (Optional - for future use) ==========

  /// أخضر - للحالات الناجحة
  static const Color success = Color(0xFF10B981);

  /// أحمر - للأخطاء والتحذيرات
  static const Color error = Color(0xFFEF4444);

  /// أصفر - للتنبيهات
  static const Color warning = Color(0xFFF59E0B);

  /// أزرق فاتح - للمعلومات
  static const Color info = Color(0xFF3B82F6);
}
