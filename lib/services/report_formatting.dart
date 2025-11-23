import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ReportFormatting {
  static void applyFormatting(Worksheet sheet) {
    int maxRow = sheet.getLastRow();
    int maxCol = sheet.getLastColumn();

    if (maxRow == 0 || maxCol == 0) return;

    // 1. Apply Header Style (Row 1)
    for (int c = 1; c <= maxCol; c++) {
      Range cell = sheet.getRangeByIndex(1, c);
      cell.cellStyle.fontName = 'Arial';
      cell.cellStyle.fontSize = 12;
      cell.cellStyle.bold = true;
      cell.cellStyle.backColor = '#4F81BD';
      cell.cellStyle.fontColor = '#FFFFFF';
      cell.cellStyle.borders.all.lineStyle = LineStyle.thin;
      cell.cellStyle.borders.all.color = '#000000';
      cell.cellStyle.hAlign = HAlignType.center;
      cell.cellStyle.vAlign = VAlignType.center;
    }

    // 2. Identify Summary Rows
    List<int> summaryRows = [];
    for (int r = 2; r <= maxRow; r++) {
      var firstCellVal = sheet.getRangeByIndex(r, 1).text;
      if (_isSummaryRow(firstCellVal)) {
        summaryRows.add(r);
      }
    }

    // 3. Apply Data Style (Rows 2 to maxRow)
    for (int r = 2; r <= maxRow; r++) {
      for (int c = 1; c <= maxCol; c++) {
        Range cell = sheet.getRangeByIndex(r, c);
        if (summaryRows.contains(r)) {
          cell.cellStyle.fontName = 'Arial';
          cell.cellStyle.fontSize = 11;
          cell.cellStyle.bold = true;
          cell.cellStyle.backColor = '#C6EFCE';
          cell.cellStyle.fontColor = '#006100';
          cell.cellStyle.borders.all.lineStyle = LineStyle.thin;
          cell.cellStyle.borders.all.color = '#000000';
          cell.cellStyle.hAlign = HAlignType.center;
        } else {
          cell.cellStyle.fontName = 'Arial';
          cell.cellStyle.fontSize = 10;
          cell.cellStyle.bold = true;
          cell.cellStyle.backColor = '#E8F5E8';
          cell.cellStyle.fontColor = '#006400';
          cell.cellStyle.borders.all.lineStyle = LineStyle.medium;
          cell.cellStyle.borders.all.color = '#006400';
          cell.cellStyle.hAlign = HAlignType.center;
          cell.cellStyle.vAlign = VAlignType.center;
        }
      }
    }

    // 4. Apply First Column Border Style (if not summary)
    for (int r = 2; r <= maxRow; r++) {
      if (!summaryRows.contains(r)) {
         Range cell = sheet.getRangeByIndex(r, 1);
         cell.cellStyle.borders.all.lineStyle = LineStyle.thick;
         cell.cellStyle.borders.all.color = '#006400';
      }
    }

    // 5. Auto-fit columns
    for (int c = 1; c <= maxCol; c++) {
      sheet.autoFitColumn(c);
    }
    
    // 6. Conditional Formatting for Efficiency
    _addConditionalFormatting(sheet, maxRow, maxCol);
  }

  static bool _isSummaryRow(String? val) {
    if (val == null) return false;
    val = val.trim();
    return ['المجموع', 'مجموع', 'الإجمالي', 'إجمالي', 'Total', 'TOTAL'].contains(val);
  }

  static void _addConditionalFormatting(Worksheet sheet, int maxRow, int maxCol) {
    // Find 'Efficiency' or 'نسبة الاستهلاك' column
    int efficiencyCol = -1;
    for (int c = 1; c <= maxCol; c++) {
      String header = sheet.getRangeByIndex(1, c).text ?? "";
      if (header.contains('كفاءة') || header.contains('نسبة الاستهلاك')) {
        efficiencyCol = c;
        break;
      }
    }

    if (efficiencyCol != -1) {
      // Conditional formatting usually works on ranges.
      // Let's try to apply it to the column range (excluding header).
      try {
        Range range = sheet.getRangeByIndex(2, efficiencyCol, maxRow, efficiencyCol);
        ConditionalFormats conditions = range.conditionalFormats;
        ConditionalFormat condition = conditions.addCondition();
        condition.formatType = ExcelCFType.cellValue;
        condition.operator = ExcelComparisonOperator.greater;
        condition.firstFormula = '80';
        
        condition.backColor = '#C6EFCE';
        condition.fontColor = '#006100';
      } catch (e) {
        // Ignore if conditional formatting fails
      }
    }
  }
}
