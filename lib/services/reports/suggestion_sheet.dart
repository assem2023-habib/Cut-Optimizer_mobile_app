import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import '../../models/config.dart';
import '../report_formatting.dart';
import 'dart:math';

void createSimpleSuggestionSheet(
  Workbook workbook,
  List<List<GroupCarpet>>? suggestedGroups,
  int minWidth,
  int maxWidth,
  MeasurementUnit unit,
) {
  // Always create the sheet, even if no suggestions
  final Worksheet sheet = workbook.worksheets.addWithName('اقتراحات المتبقيات');
  sheet.isRightToLeft = true;

  // Helper for conversion
  double convert(num value) {
    if (unit == MeasurementUnit.cm) {
      return value.toDouble();
    } else {
      return value / 100.0;
    }
  }

  String unitLabel = unit == MeasurementUnit.cm ? ' (سم)' : ' (م)';

  List<String> headers = [
    '',
    'رقم الاقتراح',
    'الطلبية الأصلية',
    'العرض الأصلي$unitLabel',
    'الطول الأصلي$unitLabel',
    'الكمية الأصلية',
    'العرض المقترح$unitLabel',
    'الطول المقترح$unitLabel',
    'الكمية المقترحة',
    'العرض الإجمالي$unitLabel',
  ];

  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  if (suggestedGroups == null || suggestedGroups.isEmpty) {
    // Add a "No suggestions" message
    sheet.getRangeByIndex(2, 1).setText('لا توجد اقتراحات متاحة');
    sheet.getRangeByIndex(2, 2).setText('جميع القطع متوافقة مع العرض الأقصى');
    return;
  }

  int rowIndex = 2;
  int suggestionId = 0;

  for (var suggestionGroups in suggestedGroups) {
    suggestionId++;
    
    for (var group in suggestionGroups) {
      if (group.items.length >= 2) {
        var originalItem = group.items[0];
        var complementaryItem = group.items[1];
        
        // Convert CarpetUsed to Carpet for display
        var original = Carpet(
          id: originalItem.carpetId,
          width: originalItem.width,
          height: originalItem.height,
          qty: originalItem.qtyUsed + originalItem.qtyRem,
          clientOrder: originalItem.clientOrder,
        );
        
        var complementary = Carpet(
          id: complementaryItem.carpetId,
          width: complementaryItem.width,
          height: complementaryItem.height,
          qty: complementaryItem.qtyUsed + complementaryItem.qtyRem,
          clientOrder: complementaryItem.clientOrder,
        );
        
        double displayOriginalWidth = convert(original.width);
        double displayOriginalHeight = convert(original.height);
        double displayComplementaryWidth = convert(complementary.width);
        double displayComplementaryHeight = convert(complementary.height);
        double displayTotalWidth = convert(original.width + complementary.width);
        
        // Round values to 2 decimal places
        displayOriginalWidth = double.parse(displayOriginalWidth.toStringAsFixed(2));
        displayOriginalHeight = double.parse(displayOriginalHeight.toStringAsFixed(2));
        displayComplementaryWidth = double.parse(displayComplementaryWidth.toStringAsFixed(2));
        displayComplementaryHeight = double.parse(displayComplementaryHeight.toStringAsFixed(2));
        displayTotalWidth = double.parse(displayTotalWidth.toStringAsFixed(2));

        // Original item
        sheet.getRangeByIndex(rowIndex, 1).setText('اقتراح_$suggestionId');
        sheet.getRangeByIndex(rowIndex, 2).setNumber(original.id.toDouble());
        sheet.getRangeByIndex(rowIndex, 3).setNumber(original.clientOrder.toDouble());
        sheet.getRangeByIndex(rowIndex, 4).setNumber(displayOriginalWidth);
        sheet.getRangeByIndex(rowIndex, 5).setNumber(displayOriginalHeight);
        sheet.getRangeByIndex(rowIndex, 6).setNumber(original.qty.toDouble());
        sheet.getRangeByIndex(rowIndex, 7).setNumber(displayComplementaryWidth);
        sheet.getRangeByIndex(rowIndex, 8).setNumber(displayComplementaryHeight);
        sheet.getRangeByIndex(rowIndex, 9).setNumber(complementary.qty.toDouble());
        sheet.getRangeByIndex(rowIndex, 10).setNumber(displayTotalWidth);
        
        rowIndex++;
      }
    }
    
    // Add empty row between suggestions
    rowIndex++;
  }

  // Apply borders to all cells
  ReportFormatting.applyBordersToAllCells(sheet);
}
