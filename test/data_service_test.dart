import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/services/data_service.dart';
import 'package:cut_optimizer_mobile/models/carpet.dart';
import 'package:cut_optimizer_mobile/models/group_carpet.dart';
import 'package:cut_optimizer_mobile/models/carpet_used.dart';
import 'dart:io';

void main() {
  group('DataService Tests', () {
    late DataService service;
    late String testInputPath;
    late String testOutputPath;

    setUp(() {
      service = DataService();
      testInputPath = 'test_input_data.xlsx';
      testOutputPath = 'test_output_data.xlsx';
    });

    tearDown(() {
      if (File(testInputPath).existsSync()) {
        File(testInputPath).deleteSync();
      }
      if (File(testOutputPath).existsSync()) {
        File(testOutputPath).deleteSync();
      }
    });

    test('Write Output Excel - Basic Execution', () async {
      final c1 = Carpet(id: 1, width: 100, height: 200, qty: 1, clientOrder: 1);
      final item1 = CarpetUsed(
          carpetId: 1, width: 100, height: 200, qtyUsed: 1, qtyRem: 0, clientOrder: 1);
      final group = GroupCarpet(groupId: 1, items: [item1]);

      await service.writeOutputExcel(
        path: testOutputPath,
        groups: [group],
        remaining: [c1],
        minWidth: 200,
        maxWidth: 200,
        toleranceLength: 0,
        originals: [c1],
      );

      expect(File(testOutputPath).existsSync(), true);
    });
    
    // Note: Testing readInputExcel requires a valid Excel file which is hard to create in test without using the library itself.
    // Since we tested ExcelService separately, and DataService just delegates, we can rely on that or do a simple check if we can create a file.
    // For now, we trust ExcelService tests.
  });
}
