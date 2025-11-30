import 'package:flutter/foundation.dart';
import '../../models/group_carpet.dart';
import '../../models/carpet.dart';
import '../../services/results_storage_service.dart';

/// حالة التطبيق المركزية
/// تحتوي على جميع البيانات المشتركة بين الشاشات
class AppState extends ChangeNotifier {
  // البيانات
  List<GroupCarpet>? _groups;
  List<Carpet>? _remaining;
  List<Carpet>? _originalGroups;
  List<List<GroupCarpet>>? _suggestedGroups;
  String? _outputFilePath;
  int? _minWidth;
  int? _maxWidth;
  int? _tolerance;

  // Getters
  List<GroupCarpet>? get groups => _groups;
  List<Carpet>? get remaining => _remaining;
  List<Carpet>? get originalGroups => _originalGroups;
  List<List<GroupCarpet>>? get suggestedGroups => _suggestedGroups;
  String? get outputFilePath => _outputFilePath;
  int? get minWidth => _minWidth;
  int? get maxWidth => _maxWidth;
  int? get tolerance => _tolerance;

  /// هل توجد بيانات محفوظة؟
  bool get hasProcessedData => _groups != null && _remaining != null;

  /// تحميل البيانات المحفوظة
  Future<void> loadStoredResults() async {
    try {
      final hasData = await ResultsStorageService.instance.hasStoredData();

      if (hasData) {
        final data = await ResultsStorageService.instance.loadResults();

        if (data != null) {
          _groups = data['groups'] as List<GroupCarpet>?;
          _remaining = data['remaining'] as List<Carpet>?;
          _originalGroups = data['originalGroups'] as List<Carpet>?;
          _suggestedGroups =
              data['suggestedGroups'] as List<List<GroupCarpet>>?;
          _outputFilePath = data['outputFilePath'] as String?;
          _minWidth = data['minWidth'] as int?;
          _maxWidth = data['maxWidth'] as int?;
          _tolerance = data['tolerance'] as int?;

          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error loading stored results: $e');
    }
  }

  /// تحديث البيانات بعد عملية جديدة
  void updateResults({
    required List<GroupCarpet> groups,
    required List<Carpet> remaining,
    List<Carpet>? originalGroups,
    List<List<GroupCarpet>>? suggestedGroups,
    String? outputFilePath,
    int? minWidth,
    int? maxWidth,
    int? tolerance,
  }) {
    _groups = groups;
    _remaining = remaining;
    _originalGroups = originalGroups;
    _suggestedGroups = suggestedGroups;
    _outputFilePath = outputFilePath;
    _minWidth = minWidth;
    _maxWidth = maxWidth;
    _tolerance = tolerance;

    notifyListeners();
  }

  /// مسح البيانات
  Future<void> clearResults() async {
    _groups = null;
    _remaining = null;
    _originalGroups = null;
    _suggestedGroups = null;
    _outputFilePath = null;
    _minWidth = null;
    _maxWidth = null;
    _tolerance = null;

    await ResultsStorageService.instance.clearResults();
    notifyListeners();
  }
}
