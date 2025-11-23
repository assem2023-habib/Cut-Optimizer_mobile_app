import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/services/excel_service.dart';
import 'package:excel/excel.dart';
import 'dart:io';

void main() {
  group('ExcelService Tests', () {
    late ExcelService service;
    late String testFilePath;

    setUp(() {
      service = ExcelService();
      testFilePath = 'test_input.xlsx';
    });

    tearDown(() {
      if (File(testFilePath).existsSync()) {
        File(testFilePath).deleteSync();
      }
    });

    test('Read Input Excel - Valid Data', () async {
      // Create a dummy Excel file
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      
      // Add data
      // Row 1: 101, 100, 200, 10, "", "", "" -> Normal
      sheetObject.appendRow([IntCellValue(101), IntCellValue(100), IntCellValue(200), IntCellValue(10)]);
      
      // Row 2: 102, 100, 200, 10, "A", "", "" -> Single Pair (qty/2) -> 5
      sheetObject.appendRow([IntCellValue(102), IntCellValue(100), IntCellValue(200), IntCellValue(10), TextCellValue("A")]);
      
      // Row 3: 103, 100, 200, 10, "", "B", "" -> Texture B (swap w/h) -> w=200, h=100
      sheetObject.appendRow([IntCellValue(103), IntCellValue(100), IntCellValue(200), IntCellValue(10), TextCellValue(""), TextCellValue("B")]);
      
      // Row 4: 104, 100, 200, 10, "", "", "A" -> Prep A (h+8) -> h=208
      sheetObject.appendRow([IntCellValue(104), IntCellValue(100), IntCellValue(200), IntCellValue(10), TextCellValue(""), TextCellValue(""), TextCellValue("A")]);

      var fileBytes = excel.save();
      File(testFilePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes!);

      final carpets = await service.readInputExcel(testFilePath);

      expect(carpets.length, 4);
      
      // Check Row 1
      expect(carpets[0].clientOrder, 101);
      expect(carpets[0].width, 100);
      expect(carpets[0].height, 200);
      expect(carpets[0].qty, 10);
      
      // Check Row 2
      expect(carpets[1].clientOrder, 102);
      expect(carpets[1].qty, 5);
      
      // Check Row 3
      expect(carpets[2].clientOrder, 103);
      expect(carpets[2].width, 200);
      expect(carpets[2].height, 100);
      
      // Check Row 4
      expect(carpets[3].clientOrder, 104);
      expect(carpets[3].height, 208);
    });
    
    test('Read Input Excel - Invalid File', () async {
        expect(() async => await service.readInputExcel("non_existent.xlsx"), throwsA(isA<FileSystemException>()));
    });
  });
}
