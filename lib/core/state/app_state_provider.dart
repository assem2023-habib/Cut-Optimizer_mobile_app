import 'package:flutter/material.dart';
import 'app_state.dart';

/// Provider للحالة المركزية
/// يوفر الوصول لـ AppState لجميع الشاشات الفرعية
class AppStateProvider extends InheritedWidget {
  final AppState appState;

  const AppStateProvider({
    super.key,
    required this.appState,
    required super.child,
  });

  /// الوصول للحالة من أي مكان في شجرة الـ widgets
  static AppState of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'AppStateProvider not found in widget tree');
    return provider!.appState;
  }

  /// التحقق من وجود Provider
  static AppState? maybeOf(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AppStateProvider>();
    return provider?.appState;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) {
    return appState != oldWidget.appState;
  }
}

/// Widget الأساسي الذي يغلف التطبيق
class AppStateWrapper extends StatefulWidget {
  final Widget child;

  const AppStateWrapper({super.key, required this.child});

  @override
  State<AppStateWrapper> createState() => _AppStateWrapperState();
}

class _AppStateWrapperState extends State<AppStateWrapper> {
  late AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();

    // تحميل البيانات المحفوظة عند بدء التطبيق
    _appState.loadStoredResults();

    // الاستماع للتغييرات
    _appState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChanged);
    _appState.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    // إعادة بناء الـ widget عند تغيير الحالة
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppStateProvider(appState: _appState, child: widget.child);
  }
}
