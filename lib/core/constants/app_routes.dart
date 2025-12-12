/// مسارات التنقل في التطبيق
/// جميع المسارات معرفة هنا لسهولة الصيانة والتعديل
class AppRoutes {
  AppRoutes._(); // Private constructor

  // ========== Main Routes ==========

  /// الصفحة الرئيسية (Home)
  /// المسار: '/'
  static const String home = '/';

  /// صفحة رفع الملفات (Upload)
  /// المسار: '/upload'
  static const String upload = '/upload';

  /// صفحة خيارات المعالجة (Processing Options)
  /// المسار: '/processing-options'
  /// تدمج: set_constraints + grouping_mode + sorting_options
  static const String processingOptions = '/processing-options';

  /// صفحة المعالجة / Loader (Processing)
  /// المسار: '/processing'
  /// من: execution_screen
  static const String processing = '/processing';

  /// صفحة الإعدادات (Settings)
  /// المسار: '/settings'
  static const String settings = '/settings';

  /// صفحة النتائج (Results)
  /// المسار: '/results'
  static const String results = '/results';

  /// صفحة التقارير (Reports)
  /// المسار: '/reports'
  /// صفحة جديدة
  static const String reports = '/reports';

  /// صفحة الإحصائيات (Statistics)
  /// المسار: '/statistics'
  /// صفحة جديدة
  static const String statistics = '/statistics';

  /// صفحة فحص النظام (System Checker)
  /// المسار: '/checker'
  static const String checker = '/checker';

  // ========== Helper Methods ==========

  /// قائمة بجميع المسارات الرئيسية
  static List<String> get allRoutes => [
    home,
    upload,
    processingOptions,
    processing,
    settings,
    results,
    reports,
    statistics,
    checker,
  ];

  /// المسارات التي تحتاج بيانات معالجة (disabled حتى تتم المعالجة)
  static List<String> get routesRequiringProcessedData => [reports, statistics];

  /// التحقق من أن المسار يحتاج بيانات معالجة
  static bool requiresProcessedData(String route) {
    return routesRequiringProcessedData.contains(route);
  }

  /// الحصول على اسم الصفحة من المسار
  static String getPageName(String route) {
    switch (route) {
      case home:
        return 'home';
      case upload:
        return 'upload';
      case processingOptions:
        return 'processing-options';
      case processing:
        return 'processing';
      case settings:
        return 'settings';
      case results:
        return 'results';
      case reports:
        return 'reports';
      case statistics:
        return 'statistics';
      case checker:
        return 'checker';
      default:
        return 'home';
    }
  }
}
