import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/group_carpet.dart';
import '../../models/carpet.dart';

void createWasteSheet(
  Workbook workbook,
  List<GroupCarpet> groups,
  int maxWidth,
  List<Carpet>? originals,
) {
  final Worksheet sheet = workbook.worksheets.addWithName('الهادر');

  List<String> headers = [
    'رقم القصة',
    'العرض الإجمالي',
    'الهادر في العرض',
    'المسار المرجعي',
    'هادر المسارات',
    'نسبة الهدر',
  ];

  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
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

    sheet.getRangeByIndex(rowIndex, 1).setText('القصة_$groupId');
    sheet.getRangeByIndex(rowIndex, 2).setNumber(g.totalWidth.toDouble());
    sheet.getRangeByIndex(rowIndex, 3).setNumber(wasteWidth);
    sheet.getRangeByIndex(rowIndex, 4).setNumber(maxPath.toDouble());
    sheet.getRangeByIndex(rowIndex, 5).setNumber(pathWaste);
    sheet.getRangeByIndex(rowIndex, 6).setNumber(wastePercentage);

    totalWidth += g.totalWidth;
    totalWasteWidth += wasteWidth;
    totalMaxPath += maxPath;
    totalPathWaste += pathWaste;
    totalWastePercentage += wastePercentage;

    rowIndex++;
  }

  rowIndex++;

  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 3).setNumber(totalWasteWidth);
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalMaxPath);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalPathWaste);
  sheet.getRangeByIndex(rowIndex, 6).setNumber(totalWastePercentage);
}
