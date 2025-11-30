import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/group_carpet.dart';
import '../models/carpet.dart';
import '../models/carpet_used.dart';

/// خدمة تخزين وتحميل نتائج المعالجة
/// تستخدم SharedPreferences لحفظ آخر عملية تحسين تمت بنجاح
class ResultsStorageService {
  static const String _resultsKey = 'last_optimization_results';
  static const String _hasDataKey = 'has_processed_data';
  static SharedPreferences? _prefs;

  // Private constructor
  ResultsStorageService._();

  // Singleton instance
  static final ResultsStorageService instance = ResultsStorageService._();

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// حفظ نتائج المعالجة
  Future<bool> saveResults({
    required List<GroupCarpet> groups,
    required List<Carpet> remaining,
    List<Carpet>? originalGroups,
    List<List<GroupCarpet>>? suggestedGroups,
    required String outputFilePath,
    required int minWidth,
    required int maxWidth,
    required int tolerance,
  }) async {
    if (_prefs == null) await init();

    try {
      final Map<String, dynamic> data = {
        'groups': groups.map((g) => _groupToJson(g)).toList(),
        'remaining': remaining.map((c) => _carpetToJson(c)).toList(),
        'originalGroups': originalGroups?.map((c) => _carpetToJson(c)).toList(),
        'suggestedGroups': suggestedGroups
            ?.map((sg) => sg.map((g) => _groupToJson(g)).toList())
            .toList(),
        'outputFilePath': outputFilePath,
        'minWidth': minWidth,
        'maxWidth': maxWidth,
        'tolerance': tolerance,
        'timestamp': DateTime.now().toIso8601String(),
      };

      final String jsonString = jsonEncode(data);
      final bool success = await _prefs!.setString(_resultsKey, jsonString);

      if (success) {
        await _prefs!.setBool(_hasDataKey, true);
      }

      return success;
    } catch (e) {
      debugPrint('Error saving results: $e');
      return false;
    }
  }

  /// تحميل نتائج المعالجة المحفوظة
  Future<Map<String, dynamic>?> loadResults() async {
    if (_prefs == null) await init();

    try {
      final String? jsonString = _prefs!.getString(_resultsKey);
      if (jsonString != null) {
        final Map<String, dynamic> data = jsonDecode(jsonString);

        return {
          'groups': (data['groups'] as List<dynamic>)
              .map((g) => _jsonToGroup(g as Map<String, dynamic>))
              .toList(),
          'remaining': (data['remaining'] as List<dynamic>)
              .map((c) => _jsonToCarpet(c as Map<String, dynamic>))
              .toList(),
          'originalGroups': data['originalGroups'] != null
              ? (data['originalGroups'] as List<dynamic>)
                    .map((c) => _jsonToCarpet(c as Map<String, dynamic>))
                    .toList()
              : null,
          'suggestedGroups': data['suggestedGroups'] != null
              ? (data['suggestedGroups'] as List<dynamic>)
                    .map(
                      (sg) => (sg as List<dynamic>)
                          .map((g) => _jsonToGroup(g as Map<String, dynamic>))
                          .toList(),
                    )
                    .toList()
              : null,
          'outputFilePath': data['outputFilePath'] as String,
          'minWidth': data['minWidth'] as int,
          'maxWidth': data['maxWidth'] as int,
          'tolerance': data['tolerance'] as int,
          'timestamp': data['timestamp'] as String,
        };
      }
    } catch (e) {
      debugPrint('Error loading results: $e');
    }

    return null;
  }

  /// التحقق من وجود بيانات محفوظة
  Future<bool> hasStoredData() async {
    if (_prefs == null) await init();
    return _prefs!.getBool(_hasDataKey) ?? false;
  }

  /// مسح البيانات المحفوظة
  Future<bool> clearResults() async {
    if (_prefs == null) await init();

    try {
      await _prefs!.remove(_resultsKey);
      await _prefs!.setBool(_hasDataKey, false);
      return true;
    } catch (e) {
      debugPrint('Error clearing results: $e');
      return false;
    }
  }

  // Helper methods for JSON conversion

  Map<String, dynamic> _groupToJson(GroupCarpet group) {
    return {
      'groupId': group.groupId,
      'repetitions': group.repetitions,
      'items': group.items
          .map(
            (item) => {
              'carpetId': item.carpetId,
              'width': item.width,
              'height': item.height,
              'qtyUsed': item.qtyUsed,
              'qtyRem': item.qtyRem,
              'clientOrder': item.clientOrder,
              'repeated': item.repeated,
            },
          )
          .toList(),
    };
  }

  GroupCarpet _jsonToGroup(Map<String, dynamic> json) {
    return GroupCarpet(
      groupId: json['groupId'] as int,
      repetitions: json['repetitions'] as int,
      items: (json['items'] as List<dynamic>)
          .map(
            (item) => CarpetUsed(
              carpetId: item['carpetId'] as int,
              width: item['width'] as int,
              height: item['height'] as int,
              qtyUsed: item['qtyUsed'] as int,
              qtyRem: item['qtyRem'] as int,
              clientOrder: item['clientOrder'] as int,
              repeated: item['repeated'] != null
                  ? (item['repeated'] as List<dynamic>)
                        .map((r) => Map<String, dynamic>.from(r as Map))
                        .toList()
                  : [],
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> _carpetToJson(Carpet carpet) {
    return {
      'id': carpet.id,
      'width': carpet.width,
      'height': carpet.height,
      'qty': carpet.qty,
      'clientOrder': carpet.clientOrder,
      'remQty': carpet.remQty,
      'repeated': carpet.repeated,
    };
  }

  Carpet _jsonToCarpet(Map<String, dynamic> json) {
    return Carpet(
      id: json['id'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      qty: json['qty'] as int,
      clientOrder: json['clientOrder'] as int,
      repeated: json['repeated'] != null
          ? (json['repeated'] as List<dynamic>)
                .map((r) => Map<String, dynamic>.from(r as Map))
                .toList()
          : [],
    )..remQty = json['remQty'] as int;
  }
}
