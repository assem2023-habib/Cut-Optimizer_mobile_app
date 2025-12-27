import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/group_carpet.dart';
import '../../models/config.dart';
import '../report_formatting.dart';

void createGroupDetailsSheet(
  Workbook workbook,
  List<GroupCarpet> groups,
  MeasurementUnit unit,
) {
  Worksheet sheet;
  if (workbook.worksheets.count > 0 &&
      workbook.worksheets[0].name == 'Sheet1') {
    sheet = workbook.worksheets[0];
    sheet.name = 'تفاصيل القصات';
  } else {
    sheet = workbook.worksheets.addWithName('تفاصيل القصات');
  }
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

  // --- 1. Generate Styles & Colors ---

  // Generate unique colors for each group (Cut)
  List<String> colors = ReportFormatting.generateReadableColors(groups.length);

  // Create styles for each group
  Map<int, Style> groupStyles = {};
  Map<int, Style> groupFirstColStyles = {};
  for (int i = 0; i < groups.length; i++) {
    // Group ID is 1-based usually in display
    groupStyles[i + 1] = ReportFormatting.createCutStyle(
      workbook,
      'القصة_${i + 1}',
      colors[i],
    );
    groupFirstColStyles[i + 1] = ReportFormatting.createCutStyle(
      workbook,
      'القصة_${i + 1}',
      colors[i],
      isFirstColumn: true,
    );
  }

  // Create basic styles
  Style headerStyle = ReportFormatting.createHeaderStyle(workbook);
  Style summaryStyle = ReportFormatting.createSummaryStyle(workbook);
  Style summaryFirstColStyle = ReportFormatting.createSummaryStyle(
    workbook,
    isFirstColumn: true,
  );
  // Note: FirstColBorderStyle is applied via logic, not as a base style to avoid overwriting background

  // --- 2. Headers ---
  List<String> headers = [
    'امر العميل',
    'رقم القصة',
    'رقم المسار',
    'العرض$unitLabel',
    'الطول$unitLabel',
    'الكمية المستخدمة',
    'طول المسار$unitLabel',
    'الكمية الاصلية',
    'الكمية المتبقية',
    'معرف السجاد',
  ];

  for (int i = 0; i < headers.length; i++) {
    Range range = sheet.getRangeByIndex(1, i + 1);
    range.setText(headers[i]);
    range.cellStyle = headerStyle;
  }

  // --- 3. Data Rows ---
  int rowIndex = 2;
  int groupId = 0;

  double totalWidth = 0;
  double totalHeight = 0;
  int totalQtyUsed = 0;
  double totalLengthRef = 0;
  int totalQty = 0;
  int totalQtyRem = 0;

  for (var g in groups) {
    groupId++;
    int pathNum = 0;

    // Get style for this group
    Style currentStyle = groupStyles[groupId]!;

    for (var item in g.items) {
      pathNum++;

      if (item.repeated.isNotEmpty) {
        int refLength = 0;
        for (var rep in item.repeated) {
          refLength += (rep['qty'] as int) * item.height;

          // Write row data
          sheet
              .getRangeByIndex(rowIndex, 1)
              .setNumber((rep['client_order'] as int).toDouble());
          sheet.getRangeByIndex(rowIndex, 2).setText('القصة_$groupId');
          sheet.getRangeByIndex(rowIndex, 3).setText('المسار_$pathNum');
          sheet.getRangeByIndex(rowIndex, 4).setNumber(convert(item.width));
          sheet.getRangeByIndex(rowIndex, 5).setNumber(convert(item.height));
          sheet
              .getRangeByIndex(rowIndex, 6)
              .setNumber((rep['qty'] as int).toDouble());
          sheet.getRangeByIndex(rowIndex, 7).setNumber(convert(refLength));
          sheet
              .getRangeByIndex(rowIndex, 8)
              .setNumber((rep['qty_original'] as int).toDouble());
          sheet
              .getRangeByIndex(rowIndex, 9)
              .setNumber((rep['qty_rem'] as int).toDouble());
          sheet
              .getRangeByIndex(rowIndex, 10)
              .setNumber(item.carpetId.toDouble());

          // Apply Cut Style to the whole row
          // Apply Cut Style to the whole row
          sheet.getRangeByIndex(rowIndex, 1).cellStyle =
              groupFirstColStyles[groupId]!;
          for (int c = 2; c <= headers.length; c++) {
            sheet.getRangeByIndex(rowIndex, c).cellStyle = currentStyle;
          }

          rowIndex++;
        }
      } else {
        // Write row data
        sheet
            .getRangeByIndex(rowIndex, 1)
            .setNumber(item.clientOrder.toDouble());
        sheet.getRangeByIndex(rowIndex, 2).setText('القصة_$groupId');
        sheet.getRangeByIndex(rowIndex, 3).setText('المسار_$pathNum');
        sheet.getRangeByIndex(rowIndex, 4).setNumber(convert(item.width));
        sheet.getRangeByIndex(rowIndex, 5).setNumber(convert(item.height));
        sheet.getRangeByIndex(rowIndex, 6).setNumber(item.qtyUsed.toDouble());
        sheet.getRangeByIndex(rowIndex, 7).setNumber(convert(item.lengthRef));
        sheet
            .getRangeByIndex(rowIndex, 8)
            .setNumber((item.qtyUsed + item.qtyRem).toDouble());
        sheet.getRangeByIndex(rowIndex, 9).setNumber(item.qtyRem.toDouble());
        sheet.getRangeByIndex(rowIndex, 10).setNumber(item.carpetId.toDouble());

        // Apply Cut Style to the whole row
        // Apply Cut Style to the whole row
        sheet.getRangeByIndex(rowIndex, 1).cellStyle =
            groupFirstColStyles[groupId]!;
        for (int c = 2; c <= headers.length; c++) {
          sheet.getRangeByIndex(rowIndex, c).cellStyle = currentStyle;
        }

        rowIndex++;
      }

      totalQty += item.qtyUsed + item.qtyRem;
      totalQtyRem += item.qtyRem;
    }

    totalWidth += convert(g.totalWidth);
    totalHeight += convert(g.totalHeight);
    totalQtyUsed += g.totalQty;
    totalLengthRef += convert(g.totalLengthRef);

    // Add empty row after each group?
    // The spec example says "Empty row: no color".
    // My previous code added an empty row. I will keep it but ensure no style is applied (default style).
    rowIndex++;
  }

  // --- 4. Totals Row ---
  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setText('');
  sheet.getRangeByIndex(rowIndex, 3).setText('');
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalHeight);
  sheet.getRangeByIndex(rowIndex, 6).setNumber(totalQtyUsed.toDouble());
  sheet.getRangeByIndex(rowIndex, 7).setNumber(totalLengthRef);
  sheet.getRangeByIndex(rowIndex, 8).setNumber(totalQty.toDouble());
  sheet.getRangeByIndex(rowIndex, 9).setNumber(totalQtyRem.toDouble());
  sheet.getRangeByIndex(rowIndex, 10).setText('');

  // Apply Summary Style
  sheet.getRangeByIndex(rowIndex, 1).cellStyle = summaryFirstColStyle;
  for (int c = 2; c <= headers.length; c++) {
    sheet.getRangeByIndex(rowIndex, c).cellStyle = summaryStyle;
  }

  // --- 5. Post-Processing ---

  // Apply First Column Border (Stage 7)
  // Already handled by groupFirstColStyles

  // Auto-fit columns (Stage 6)
  ReportFormatting.applyAutoFit(sheet);

  // Conditional Formatting (Stage 8)
  // Not applicable here as 'Efficiency' column is not in this sheet, but if it were:
  // ReportFormatting.addConditionalFormatting(sheet, rowIndex, headers.length);

  // Row Highlight (Stage 9)
  ReportFormatting.applyRowHighlight(sheet);
}
