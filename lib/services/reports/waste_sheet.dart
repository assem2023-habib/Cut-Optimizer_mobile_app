import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/group_carpet.dart';
import '../../models/carpet.dart';
import '../../models/config.dart';

void createWasteSheet(
  Workbook workbook,
  List<GroupCarpet> groups,
  int maxWidth,
  List<Carpet>? originals,
  MeasurementUnit unit,
) {
  final Worksheet sheet = workbook.worksheets.addWithName('الهادر');
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
  String areaLabel = unit == MeasurementUnit.cm ? ' (سم²)' : ' (م²)';

  List<String> headers = [
    'رقم القصة',
    'العرض الإجمالي$unitLabel',
    'الهادر في العرض$unitLabel',
    'المسار المرجعي$unitLabel',
    'هادر المسارات$areaLabel',
    'نسبة الهدر',
  ];

  // Apply header style with borders
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

  // Calculate total original area
  double totalOriginal = 0;
  if (originals != null && originals.isNotEmpty) {
    for (var carpet in originals) {
      totalOriginal += carpet.area * carpet.qty;
    }
  } else {
    // Fallback: calculate from groups if originals not available
    for (var group in groups) {
      for (var carpet in group.items) {
        totalOriginal += carpet.area * (carpet.qtyUsed + carpet.qtyRem);
      }
    }
  }

  int rowIndex = 2;
  int groupId = 0;

  double totalWidth = 0;
  double totalWasteWidth = 0;
  double totalMaxPath = 0;
  double totalPathWaste = 0;
  double totalWastePercentage = 0;

  for (var g in groups) {
    groupId++;

    // Waste in width = maxWidth - totalWidth of group
    double wasteWidth = (maxWidth - g.totalWidth).toDouble();

    // Max path (reference path) = longest path in the group
    int maxPath = g.maxLengthRef;

    // Path waste = sum of (maxPath - itemPath) * itemWidth for all items
    double pathWaste = 0;
    for (var item in g.items) {
      pathWaste += (maxPath - item.lengthRef) * item.width;
    }

    // Add width waste area to path waste
    pathWaste += wasteWidth * maxPath;

    // Waste percentage for this group = (pathWaste / totalOriginal) * 100
    double wastePercentage = totalOriginal > 0
        ? (pathWaste / totalOriginal * 100)
        : 0;

    double displayWidth = convert(g.totalWidth);
    double displayWasteWidth = convert(wasteWidth);
    double displayMaxPath = convert(maxPath);

    // Path waste is area.
    // If cm: cm * cm = cm2.
    // If m: m * m = m2.
    // So we need to convert pathWaste area.
    double displayPathWaste = unit == MeasurementUnit.cm
        ? pathWaste
        : pathWaste / 10000.0;

    // Round values to 2 decimal places
    displayWidth = double.parse(displayWidth.toStringAsFixed(2));
    displayWasteWidth = double.parse(displayWasteWidth.toStringAsFixed(2));
    displayMaxPath = double.parse(displayMaxPath.toStringAsFixed(2));
    displayPathWaste = double.parse(displayPathWaste.toStringAsFixed(2));
    wastePercentage = double.parse(wastePercentage.toStringAsFixed(2));

    // Set values
    sheet.getRangeByIndex(rowIndex, 1).setText('القصة_$groupId');
    sheet.getRangeByIndex(rowIndex, 2).setNumber(displayWidth);
    sheet.getRangeByIndex(rowIndex, 3).setNumber(displayWasteWidth);
    sheet.getRangeByIndex(rowIndex, 4).setNumber(displayMaxPath);
    sheet.getRangeByIndex(rowIndex, 5).setNumber(displayPathWaste);

    // Set percentage with % symbol
    sheet.getRangeByIndex(rowIndex, 6).setText('$wastePercentage%');

    // Apply borders to data rows
    for (int c = 1; c <= headers.length; c++) {
      Range cell = sheet.getRangeByIndex(rowIndex, c);
      cell.cellStyle.borders.all.lineStyle = LineStyle.medium;
      cell.cellStyle.borders.all.color = '#000000';
      cell.cellStyle.hAlign = HAlignType.center;
      cell.cellStyle.vAlign = VAlignType.center;
    }

    totalWidth += displayWidth;
    totalWasteWidth += displayWasteWidth;
    totalMaxPath += displayMaxPath;
    totalPathWaste += displayPathWaste;
    totalWastePercentage += wastePercentage;

    rowIndex++;
  }

  rowIndex++;

  // Round total values to 2 decimal places
  totalWidth = double.parse(totalWidth.toStringAsFixed(2));
  totalWasteWidth = double.parse(totalWasteWidth.toStringAsFixed(2));
  totalMaxPath = double.parse(totalMaxPath.toStringAsFixed(2));
  totalPathWaste = double.parse(totalPathWaste.toStringAsFixed(2));
  totalWastePercentage = double.parse(totalWastePercentage.toStringAsFixed(2));

  // Set total row values
  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 3).setNumber(totalWasteWidth);
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalMaxPath);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalPathWaste);

  // Set total percentage with % symbol
  sheet.getRangeByIndex(rowIndex, 6).setText('$totalWastePercentage%');

  // Apply borders and bold style to total row
  for (int c = 1; c <= headers.length; c++) {
    Range cell = sheet.getRangeByIndex(rowIndex, c);
    cell.cellStyle.bold = true;
    cell.cellStyle.borders.all.lineStyle = LineStyle.medium;
    cell.cellStyle.borders.all.color = '#000000';
    cell.cellStyle.backColor = '#C6EFCE';
    cell.cellStyle.fontColor = '#006100';
    cell.cellStyle.hAlign = HAlignType.center;
    cell.cellStyle.vAlign = VAlignType.center;
  }

  // Auto-fit columns
  for (int c = 1; c <= headers.length; c++) {
    sheet.autoFitColumn(c);
  }
}
