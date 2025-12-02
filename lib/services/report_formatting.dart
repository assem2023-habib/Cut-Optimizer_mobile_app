import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ReportFormatting {
  // --- Style Creation Methods ---

  /// 1. Header Format
  static Style createHeaderStyle(Workbook workbook) {
    final String styleName = 'HeaderStyle';
    // Check if style exists to avoid errors if called multiple times
    if (workbook.styles.contains(styleName)) {
      return workbook.styles[styleName]!;
    }

    Style style = workbook.styles.add(styleName);
    style.fontName = 'Arial';
    style.fontSize = 12;
    style.bold = true;
    style.backColor = '#4F81BD';
    style.fontColor = '#FFFFFF';
    style.borders.all.lineStyle = LineStyle.thin;
    style.borders.all.color = '#000000';
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;
    return style;
  }

  /// 2. Normal Format (Default for text)
  static Style createNormalStyle(Workbook workbook) {
    final String styleName = 'NormalStyle';
    if (workbook.styles.contains(styleName)) {
      return workbook.styles[styleName]!;
    }

    Style style = workbook.styles.add(styleName);
    style.fontName = 'Arial';
    style.fontSize = 10;
    style.bold = true;
    style.borders.all.lineStyle = LineStyle.medium; // 2 pixels roughly
    style.borders.all.color = '#006400'; // Dark Green
    style.backColor = '#E8F5E8'; // Honeydew
    style.fontColor = '#006400'; // Dark Green
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;
    return style;
  }

  /// 3. Number Format (Same as Normal but can be distinguished if needed)
  static Style createNumberStyle(Workbook workbook) {
    final String styleName = 'NumberStyle';
    if (workbook.styles.contains(styleName)) {
      return workbook.styles[styleName]!;
    }

    // Currently identical to NormalStyle as per specs, but kept separate for logic
    Style style = workbook.styles.add(styleName);
    style.fontName = 'Arial';
    style.fontSize = 10;
    style.bold = true;
    style.borders.all.lineStyle = LineStyle.medium;
    style.borders.all.color = '#006400';
    style.backColor = '#E8F5E8';
    style.fontColor = '#006400';
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;
    return style;
  }

  /// 4. Summary Row Format
  static Style createSummaryStyle(
    Workbook workbook, {
    bool isFirstColumn = false,
  }) {
    final String styleName = 'SummaryStyle${isFirstColumn ? '_FirstCol' : ''}';
    if (workbook.styles.contains(styleName)) {
      return workbook.styles[styleName]!;
    }

    Style style = workbook.styles.add(styleName);
    style.fontName = 'Arial';
    style.fontSize = 11; // Slightly larger
    style.bold = true;
    style.backColor = '#C6EFCE'; // Light Green
    style.fontColor = '#006100'; // Very Dark Green
    style.borders.all.lineStyle = LineStyle.thin;
    style.borders.all.color = '#000000';
    style.hAlign = HAlignType.center;
    // Valign not specified in python spec but usually center is good
    style.vAlign = VAlignType.center;

    if (isFirstColumn) {
      style.borders.all.lineStyle = LineStyle.thick;
      style.borders.all.color = '#006400';
    }

    return style;
  }

  /// 5. First Column Border Format
  static Style createFirstColBorderStyle(Workbook workbook) {
    final String styleName = 'FirstColBorderStyle';
    if (workbook.styles.contains(styleName)) {
      return workbook.styles[styleName]!;
    }

    Style style = workbook.styles.add(styleName);
    style.borders.all.lineStyle = LineStyle.thick; // 3 pixels roughly
    style.borders.all.color = '#006400';
    style.backColor = '#E8F5E8';
    return style;
  }

  /// Create a dynamic style for a specific Cut
  static Style createCutStyle(
    Workbook workbook,
    String cutName,
    String colorHex, {
    bool isFirstColumn = false,
  }) {
    final String styleName =
        'CutStyle_${cutName.replaceAll(' ', '_')}${isFirstColumn ? '_FirstCol' : ''}';
    if (workbook.styles.contains(styleName)) {
      return workbook.styles[styleName]!;
    }

    Style style = workbook.styles.add(styleName);
    style.fontName = 'Arial';
    style.fontSize = 10;
    style.bold = true;
    style.borders.all.lineStyle = LineStyle.medium;
    style.borders.all.color = '#006400';
    style.backColor = colorHex; // Unique color
    style.fontColor = '#2C3E50'; // Dark Grey
    style.hAlign = HAlignType.center;
    style.vAlign = VAlignType.center;

    if (isFirstColumn) {
      style.borders.all.lineStyle = LineStyle.thick;
      style.borders.all.color = '#006400';
    }

    return style;
  }

  /// Generate unique colors for groups using HSL color scheme
  /// This follows the exact specification for readable, distinct colors
  static List<String> generateGroupColors(int count) {
    return generateReadableColors(count);
  }

  /// Generate readable colors using precise HSL algorithm
  /// Uses Golden Ratio for hue distribution to ensure distinct, beautiful colors
  static List<String> generateReadableColors(int numColors) {
    List<String> colors = [];
    double goldenRatioConjugate = 0.618033988749895;
    double currentHue = 0.0;

    for (int i = 0; i < numColors; i++) {
      // Use Golden Ratio to generate well-distributed hues
      currentHue += goldenRatioConjugate;
      currentHue %= 1.0;

      // Saturation: 0.6 to 0.75 (Vibrant but comfortable)
      double saturation = 0.6 + (i % 2) * 0.15;

      // Lightness: 0.85 to 0.92 (Very light background)
      double lightness = 0.85 + (i % 2) * 0.07;

      // Convert to hex (hue needs to be in degrees 0-360)
      colors.add(_hslToHex(currentHue * 360, saturation, lightness));
    }

    return colors;
  }

  /// Convert HSL to HEX color
  static String _hslToHex(double h, double s, double l) {
    double c = (1 - (2 * l - 1).abs()) * s;
    double x = c * (1 - ((h / 60) % 2 - 1).abs());
    double m = l - c / 2;

    double r = 0, g = 0, b = 0;

    if (h >= 0 && h < 60) {
      r = c;
      g = x;
      b = 0;
    } else if (h >= 60 && h < 120) {
      r = x;
      g = c;
      b = 0;
    } else if (h >= 120 && h < 180) {
      r = 0;
      g = c;
      b = x;
    } else if (h >= 180 && h < 240) {
      r = 0;
      g = x;
      b = c;
    } else if (h >= 240 && h < 300) {
      r = x;
      g = 0;
      b = c;
    } else if (h >= 300 && h < 360) {
      r = c;
      g = 0;
      b = x;
    }

    int red = ((r + m) * 255).round();
    int green = ((g + m) * 255).round();
    int blue = ((b + m) * 255).round();

    return '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  /// Apply auto-fit to columns based on content length
  /// Logic: min(max_len + 2, 50)
  static void applyAutoFit(Worksheet sheet) {
    int maxCol = sheet.getLastColumn();
    int maxRow = sheet.getLastRow();

    for (int c = 1; c <= maxCol; c++) {
      int maxLength = 0;

      // Check header length
      String header = sheet.getRangeByIndex(1, c).text ?? '';
      maxLength = header.length;

      // Check data length (sample first 100 rows for performance if needed, or all)
      // For now, check all as per spec implication
      for (int r = 2; r <= maxRow; r++) {
        String val = sheet.getRangeByIndex(r, c).text ?? '';
        if (val.length > maxLength) {
          maxLength = val.length;
        }
      }

      // Apply formula: min(max_len + 2, 50)
      double width = (maxLength + 2).toDouble();
      if (width > 50) width = 50;

      // Set column width
      sheet.getRangeByIndex(1, c).columnWidth = width;
    }
  }

  /// Apply thick border to the first column
  /// Solves the overlap problem by modifying the existing style's border
  static void applyFirstColumnBorder(Worksheet sheet) {
    int maxRow = sheet.getLastRow();
    for (int r = 2; r <= maxRow; r++) {
      Range cell = sheet.getRangeByIndex(r, 1);
      // We only want to change the border, preserving the background color
      cell.cellStyle.borders.all.lineStyle = LineStyle.thick;
      cell.cellStyle.borders.all.color = '#006400';
    }
  }

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
    return [
      'المجموع',
      'مجموع',
      'الإجمالي',
      'إجمالي',
      'Total',
      'TOTAL',
    ].contains(val);
  }

  static void _addConditionalFormatting(
    Worksheet sheet,
    int maxRow,
    int maxCol,
  ) {
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
        Range range = sheet.getRangeByIndex(
          2,
          efficiencyCol,
          maxRow,
          efficiencyCol,
        );
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

  /// Apply row highlight on selection using formula
  /// Formula: =ROW()=CELL("row")
  static void applyRowHighlight(Worksheet sheet) {
    try {
      int maxRow = sheet.getLastRow();
      int maxCol = sheet.getLastColumn();

      if (maxRow < 2) return;

      Range range = sheet.getRangeByIndex(2, 1, maxRow, maxCol);
      ConditionalFormats conditions = range.conditionalFormats;
      ConditionalFormat condition = conditions.addCondition();
      condition.formatType = ExcelCFType.formula;
      condition.firstFormula = '=ROW()=CELL("row")';
      condition.backColor = '#FFF2CC'; // Light Yellow (Cornsilk)
    } catch (e) {
      // Ignore
    }
  }

  /// Apply medium borders to all cells in the sheet
  static void applyBordersToAllCells(Worksheet sheet) {
    int maxRow = sheet.getLastRow();
    int maxCol = sheet.getLastColumn();

    if (maxRow == 0 || maxCol == 0) return;

    for (int r = 1; r <= maxRow; r++) {
      for (int c = 1; c <= maxCol; c++) {
        Range cell = sheet.getRangeByIndex(r, c);
        cell.cellStyle.borders.all.lineStyle = LineStyle.medium;
        cell.cellStyle.borders.all.color = '#000000';
      }
    }
  }
}
