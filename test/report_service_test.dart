import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/services/report_service.dart';
import 'package:cut_optimizer_mobile/models/carpet.dart';
import 'package:cut_optimizer_mobile/models/group_carpet.dart';
import 'package:cut_optimizer_mobile/models/carpet_used.dart';
import 'dart:io';

void main() {
  group('ReportService Tests', () {
    late ReportService service;
    late String testOutputPath;

    setUp(() {
      service = ReportService();
      testOutputPath = 'test_report.xlsx';
    });

    tearDown(() {
      if (File(testOutputPath).existsSync()) {
        File(testOutputPath).deleteSync();
      }
    });

    test('Generate Report - Basic Execution', () async {
      // Create dummy data
      final c1 = Carpet(id: 1, width: 100, height: 200, qty: 1, clientOrder: 1);
      final item1 = CarpetUsed(
          carpetId: 1, width: 100, height: 200, qtyUsed: 1, qtyRem: 0, clientOrder: 1);
      final group = GroupCarpet(groupId: 1, items: [item1]);
      
      await service.generateReport(
        groups: [group],
        remaining: [c1],
        minWidth: 200,
        maxWidth: 200,
        tolerance: 0,
        outputPath: testOutputPath,
        originalGroups: [c1],
      );
      
      expect(File(testOutputPath).existsSync(), true);
    });
  });
}
