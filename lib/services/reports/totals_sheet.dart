import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import '../../models/config.dart';
import '../report_formatting.dart';

void createTotalsSheet({
  required Workbook workbook,
  required List<Carpet>? originalGroups,
  required List<GroupCarpet> groups,
  required List<Carpet> remaining,
  required MeasurementUnit unit,
  required int maxWidth,
  required int pathLength,
}) {
  final Worksheet sheet = workbook.worksheets.addWithName('الإجماليات');
  sheet.isRightToLeft = true;

  String areaLabel = unit == MeasurementUnit.cm ? ' (سم²)' : ' (م²)';

  List<String> headers = [
    '',
    'كمية الطلبية',
    'الكمية المنتجة',
    'الكمية المتبقية',
    'كمية الهادر',
    'نسبة الكمية المنتجة',
    'نسبة الهادر',
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

  // Calculate totals using Python logic
  int totalOrderQuantity = _calculateTotalOrderQuantity(originalGroups, groups);
  int totalRemainingQuantity = _calculateTotalRemainingQuantity(remaining);
  int totalProducedQuantity = _calculateTotalProducedQuantity(groups);
  int totalWasteQuantity = _calculateTotalWasteQuantity(groups, maxWidth);

  // Calculate percentages
  String producedPercentage = totalOrderQuantity > 0
      ? "${(totalProducedQuantity / totalOrderQuantity * 100).toStringAsFixed(2)}%"
      : "0.00%";

  String wastePercentage = totalOrderQuantity > 0 && totalWasteQuantity > 0
      ? "${(totalWasteQuantity / totalOrderQuantity * 100).toStringAsFixed(2)}%"
      : "0.00%";

  // Convert to display units
  double displayOrderQuantity = unit == MeasurementUnit.cm
      ? totalOrderQuantity.toDouble()
      : totalOrderQuantity / 10000.0;
  double displayProducedQuantity = unit == MeasurementUnit.cm
      ? totalProducedQuantity.toDouble()
      : totalProducedQuantity / 10000.0;
  double displayRemainingQuantity = unit == MeasurementUnit.cm
      ? totalRemainingQuantity.toDouble()
      : totalRemainingQuantity / 10000.0;
  double displayWasteQuantity = unit == MeasurementUnit.cm
      ? totalWasteQuantity.toDouble()
      : totalWasteQuantity / 10000.0;

  // Round values to 2 decimal places
  displayOrderQuantity = double.parse(displayOrderQuantity.toStringAsFixed(2));
  displayProducedQuantity = double.parse(
    displayProducedQuantity.toStringAsFixed(2),
  );
  displayRemainingQuantity = double.parse(
    displayRemainingQuantity.toStringAsFixed(2),
  );
  displayWasteQuantity = double.parse(displayWasteQuantity.toStringAsFixed(2));

  // Write data
  sheet.getRangeByIndex(2, 1).setText('');

  Range orderRange = sheet.getRangeByIndex(2, 2);
  orderRange.setNumber(displayOrderQuantity);
  orderRange.numberFormat = '#,##0.00';

  Range producedRange = sheet.getRangeByIndex(2, 3);
  producedRange.setNumber(displayProducedQuantity);
  producedRange.numberFormat = '#,##0.00';

  Range remainingRange = sheet.getRangeByIndex(2, 4);
  remainingRange.setNumber(displayRemainingQuantity);
  remainingRange.numberFormat = '#,##0.00';

  Range wasteRange = sheet.getRangeByIndex(2, 5);
  wasteRange.setNumber(displayWasteQuantity);
  wasteRange.numberFormat = '#,##0.00';
  sheet.getRangeByIndex(2, 6).setText(producedPercentage);
  sheet.getRangeByIndex(2, 7).setText(wastePercentage);

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

int _calculateTotalOrderQuantity(
  List<Carpet>? originalGroups,
  List<GroupCarpet> groups,
) {
  int total = 0;

  if (originalGroups != null && originalGroups.isNotEmpty) {
    for (var carpet in originalGroups) {
      total += carpet.area * carpet.qty;
    }
    return total;
  }

  for (var group in groups) {
    for (var item in group.items) {
      int units = item.qtyUsed + item.qtyRem;
      total += (item.width * item.height) * units;
    }
  }

  return total;
}

int _calculateTotalRemainingQuantity(List<Carpet> remaining) {
  int total = 0;

  for (var carpet in remaining) {
    if (carpet.repeated.isNotEmpty) {
      for (var rep in carpet.repeated) {
        int qty = (rep['qty_rem'] as int? ?? 0);
        if (qty > 0) {
          total += carpet.area * qty;
        }
      }
    } else {
      if (carpet.remQty > 0) {
        total += carpet.area * carpet.remQty;
      }
    }
  }

  return total;
}

int _calculateTotalProducedQuantity(List<GroupCarpet> groups) {
  int total = 0;

  for (var group in groups) {
    for (var item in group.items) {
      total += item.area;
    }
  }

  return total;
}

int _calculateTotalWasteQuantity(List<GroupCarpet> groups, int loomWidth) {
  if (groups.isEmpty) {
    return 0;
  }

  int totalWaste = 0;

  for (var group in groups) {
    if (group.items.isEmpty) {
      continue;
    }

    int groupMaxLength = group.maxLengthRef;
    int sumPathLoss = 0;

    // Calculate path loss for each item (only positive waste)
    for (var item in group.items) {
      int pathLoss = (groupMaxLength - item.lengthRef) * item.width;
      // Only add positive waste (when maxLengthRef > item.lengthRef)
      if (pathLoss > 0) {
        sumPathLoss += pathLoss;
      }
    }

    // Calculate width waste (only positive waste)
    int widthWaste = (loomWidth - group.totalWidth) * groupMaxLength;
    if (widthWaste > 0) {
      sumPathLoss += widthWaste;
    }

    totalWaste += sumPathLoss;
  }

  return totalWaste;
}
