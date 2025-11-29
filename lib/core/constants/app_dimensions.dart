/// الأبعاد الثابتة المستخدمة في التطبيق
/// جميع القياسات بالبكسل (Logical Pixels)
class AppDimensions {
  AppDimensions._(); // Private constructor

  // ========== App Container ==========

  /// العرض الأقصى للتطبيق على الشاشات الكبيرة
  /// يطابق max-w-md من Tailwind (448px)
  static const double maxAppWidth = 448.0;

  // ========== Header Dimensions ==========

  /// ارتفاع Header الثابت
  /// ~68px (16px padding top + 36px text + 16px padding bottom)
  static const double headerHeight = 68.0;

  /// حشو Header الداخلي (من جميع الجهات)
  static const double headerPadding = 16.0;

  /// حجم خط عنوان Header
  static const double headerFontSize = 36.0;

  // ========== Bottom Navigation Dimensions ==========

  /// ارتفاع Bottom Navigation الثابت
  /// ~64px (8px padding + 24px icon + 4px gap + 12px text + 8px padding)
  static const double bottomNavHeight = 64.0;

  /// المسافة بين عناصر Bottom Navigation
  /// 4px بين الأزرار
  static const double bottomNavGap = 4.0;

  /// حجم أيقونة Bottom Navigation
  static const double bottomNavIconSize = 24.0;

  /// حجم نص Bottom Navigation
  static const double bottomNavTextSize = 12.0;

  /// حشو رأسي لزر Navigation
  static const double bottomNavButtonPaddingVertical = 8.0;

  /// حشو أفقي لزر Navigation
  static const double bottomNavButtonPaddingHorizontal = 4.0;

  /// المسافة بين الأيقونة والنص في زر Navigation
  static const double bottomNavIconTextGap = 4.0;

  // ========== Content Dimensions ==========

  /// حشو سفلي للمحتوى لتجنب تداخل مع Bottom Navigation
  /// 80px (أكبر من ارتفاع Bottom Nav لإضافة مساحة آمنة)
  static const double contentPaddingBottom = 80.0;

  /// حشو جانبي افتراضي للمحتوى
  static const double contentPaddingHorizontal = 16.0;

  /// حشو رأسي افتراضي للمحتوى
  static const double contentPaddingVertical = 16.0;

  // ========== Card & Button Dimensions ==========

  /// نصف قطر حواف البطاقات (Card Border Radius)
  static const double cardRadius = 12.0;

  /// نصف قطر حواف الأزرار (Button Border Radius)
  static const double buttonRadius = 8.0;

  /// ارتفاع الزر الافتراضي
  static const double buttonHeight = 48.0;

  /// حشو جانبي للزر
  static const double buttonPaddingHorizontal = 24.0;

  /// حشو رأسي للزر
  static const double buttonPaddingVertical = 12.0;

  // ========== Spacing System ==========

  /// مسافة صغيرة جداً (4px)
  static const double spaceXS = 4.0;

  /// مسافة صغيرة (8px)
  static const double spaceSM = 8.0;

  /// مسافة متوسطة (16px)
  static const double spaceMD = 16.0;

  /// مسافة كبيرة (24px)
  static const double spaceLG = 24.0;

  /// مسافة كبيرة جداً (32px)
  static const double spaceXL = 32.0;

  /// مسافة ضخمة (48px)
  static const double space2XL = 48.0;

  // ========== Icon Sizes ==========

  /// حجم أيقونة صغيرة
  static const double iconSizeSmall = 16.0;

  /// حجم أيقونة متوسطة
  static const double iconSizeMedium = 24.0;

  /// حجم أيقونة كبيرة
  static const double iconSizeLarge = 32.0;

  // ========== Border & Shadow ==========

  /// عرض الحدود الافتراضي
  static const double borderWidth = 1.0;

  /// قوة الظل الافتراضي
  static const double shadowBlurRadius = 10.0;

  /// إزاحة الظل العمودية
  static const double shadowOffsetY = 3.0;
}
