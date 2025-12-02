import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/group_carpet.dart';
import '../../models/config.dart';
import '../report_formatting.dart';

void createGroupSummarySheet(
  Workbook workbook,
  List<GroupCarpet> groups,
  MeasurementUnit unit,
) {
  final Worksheet sheet = workbook.worksheets.addWithName('ملخص القصات');
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
    'عدد المسارات',
    'أقصى ارتفاع$unitLabel',
    'المساحة الإجمالية$areaLabel',
    'الكمية المستخدمة الكلية',
    'عدد أنواع السجاد',
    'المساحة الإجمالية (م²)', // Always keep m2 column as reference
  ];

  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  int rowIndex = 2;
  int groupId = 0;

  double totalWidth = 0;
  double totalHeight = 0;
  double totalArea = 0;
  int itemsCount = 0;
  int totalQtyUsed = 0;
  double totalAreaDiv = 0;

  for (var g in groups) {
    groupId++;
    int typesCount = g.items.length;

    double displayWidth = convert(g.totalWidth);
    double displayHeight = convert(g.maxHeight);

    // Area calculation:
    // If cm: g.totalArea is cm2.
    // If m: we want m2. g.totalArea / 10000.
    double displayArea = unit == MeasurementUnit.cm
        ? g.totalArea.toDouble()
        : (g.totalArea / 10000.0);

    // Round values to 2 decimal places
    displayWidth = double.parse(displayWidth.toStringAsFixed(2));
    displayHeight = double.parse(displayHeight.toStringAsFixed(2));
    displayArea = double.parse(displayArea.toStringAsFixed(2));
    double areaDiv = double.parse((g.totalArea / 10000).toStringAsFixed(2));

    sheet.getRangeByIndex(rowIndex, 1).setText('القصة_$groupId');
    sheet.getRangeByIndex(rowIndex, 2).setNumber(displayWidth);
    sheet.getRangeByIndex(rowIndex, 3).setNumber(g.items.length.toDouble());
    sheet.getRangeByIndex(rowIndex, 4).setNumber(displayHeight);
    sheet.getRangeByIndex(rowIndex, 5).setNumber(displayArea);
    sheet.getRangeByIndex(rowIndex, 6).setNumber(g.totalQty.toDouble());
    sheet.getRangeByIndex(rowIndex, 7).setNumber(typesCount.toDouble());
    sheet.getRangeByIndex(rowIndex, 8).setNumber(areaDiv);

    totalWidth += displayWidth;
    totalHeight += displayHeight;
    totalArea += displayArea;
    itemsCount += typesCount;
    totalQtyUsed += g.totalQty;
    totalAreaDiv += areaDiv;

    rowIndex++;
  }

  rowIndex++;

  // Round totals to 2 decimal places
  totalWidth = double.parse(totalWidth.toStringAsFixed(2));
  totalHeight = double.parse(totalHeight.toStringAsFixed(2));
  totalArea = double.parse(totalArea.toStringAsFixed(2));
  totalAreaDiv = double.parse(totalAreaDiv.toStringAsFixed(2));

  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 3).setNumber(groups.length.toDouble());
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalHeight);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalArea);
  sheet.getRangeByIndex(rowIndex, 6).setNumber(totalQtyUsed.toDouble());
  sheet.getRangeByIndex(rowIndex, 7).setNumber(itemsCount.toDouble());
  sheet.getRangeByIndex(rowIndex, 8).setNumber(totalAreaDiv);

  // Apply borders to all cells
  ReportFormatting.applyBordersToAllCells(sheet);
}
