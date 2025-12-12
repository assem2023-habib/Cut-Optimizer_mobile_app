import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import '../../models/config.dart';
import '../report_formatting.dart';

void createTotalsSheet(
  Workbook workbook,
  List<Carpet>? originalGroups,
  List<GroupCarpet> groups,
  List<Carpet> remaining,
  MeasurementUnit unit,
) {
  final Worksheet sheet = workbook.worksheets.addWithName('الإجماليات');
  sheet.isRightToLeft = true;

  String areaLabel = unit == MeasurementUnit.cm ? ' (سم²)' : ' (م²)';

  List<String> headers = [
    '',
    'الإجمالي الأصلي$areaLabel',
    'المستهلك$areaLabel',
    'المتبقي$areaLabel',
    'نسبة الاستهلاك (%)',
  ];

  for (int i = 0; i < headers.length; i++) {
    Range headerCell = sheet.getRangeByIndex(1, i + 1);
    headerCell.setText(headers[i]);
    headerCell.cellStyle.fontName = 'Arial';
    headerCell.cellStyle.fontSize = 12;
    headerCell.cellStyle.bold = true;
    headerCell.cellStyle.backColor = '#4F81BD';
    headerCell.cellStyle.fontColor = '#FFFFFF';
    headerCell.cellStyle.borders.all.lineStyle = LineStyle.medium;
    headerCell.cellStyle.borders.all.color = '#000000';
    headerCell.cellStyle.hAlign = HAlignType.center;
    headerCell.cellStyle.vAlign = VAlignType.center;
  }

  double totalOriginal = 0;
  if (originalGroups != null && originalGroups.isNotEmpty) {
    for (var carpet in originalGroups) {
      totalOriginal += carpet.area * carpet.qty;
    }
  } else {
    for (var group in groups) {
      for (var carpet in group.items) {
        totalOriginal += carpet.area * (carpet.qtyUsed + carpet.qtyRem);
      }
    }
  }

  double totalRemaining = 0;
  for (var carpet in remaining) {
    // Note: Python code iterates remaining list and calculates area * rem_qty.
    // However, if carpet has 'repeated', does it matter?
    // Python code: total_remaining += carpet.area() * carpet.rem_qty
    // `carpet.rem_qty` should be the sum of repeated rem_qtys if it's a parent, or just rem_qty.
    // In our model `remQty` is tracked on the main carpet object.
    totalRemaining += carpet.area * carpet.remQty;
  }

  double totalUsed = totalOriginal - totalRemaining;
  double consumptionRatio = totalOriginal > 0
      ? (totalUsed / totalOriginal * 100)
      : 0;

  // Convert if needed
  if (unit != MeasurementUnit.cm) {
    totalOriginal /= 10000.0;
    totalRemaining /= 10000.0;
    totalUsed /= 10000.0;
  }

  // Round values to 2 decimal places
  totalOriginal = double.parse(totalOriginal.toStringAsFixed(2));
  totalRemaining = double.parse(totalRemaining.toStringAsFixed(2));
  totalUsed = double.parse(totalUsed.toStringAsFixed(2));
  consumptionRatio = double.parse(consumptionRatio.toStringAsFixed(2));

  sheet.getRangeByIndex(2, 1).setText('');
  sheet.getRangeByIndex(2, 2).setNumber(totalOriginal);
  sheet.getRangeByIndex(2, 3).setNumber(totalUsed);
  sheet.getRangeByIndex(2, 4).setNumber(totalRemaining);
  sheet.getRangeByIndex(2, 5).setNumber(consumptionRatio);

  // Apply borders and formatting to data rows
  for (int c = 1; c <= headers.length; c++) {
    Range cell = sheet.getRangeByIndex(2, c);
    cell.cellStyle.borders.all.lineStyle = LineStyle.medium;
    cell.cellStyle.borders.all.color = '#000000';
    cell.cellStyle.hAlign = HAlignType.center;
    cell.cellStyle.vAlign = VAlignType.center;
    cell.cellStyle.fontName = 'Arial';
    cell.cellStyle.fontSize = 11;
  }

  // Auto-fit columns
  for (int c = 1; c <= headers.length; c++) {
    sheet.autoFitColumn(c);
  }
}
