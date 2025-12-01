import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/group_carpet.dart';
import '../../models/config.dart';

void createGroupSummarySheet(
  Workbook workbook,
  List<GroupCarpet> groups,
  MeasurementUnit unit,
) {
  final Worksheet sheet = workbook.worksheets.addWithName('ملخص القصات');

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

    sheet.getRangeByIndex(rowIndex, 1).setText('القصة_$groupId');
    sheet.getRangeByIndex(rowIndex, 2).setNumber(displayWidth);
    sheet.getRangeByIndex(rowIndex, 3).setNumber(g.items.length.toDouble());
    sheet.getRangeByIndex(rowIndex, 4).setNumber(displayHeight);
    sheet.getRangeByIndex(rowIndex, 5).setNumber(displayArea);
    sheet.getRangeByIndex(rowIndex, 6).setNumber(g.totalQty.toDouble());
    sheet.getRangeByIndex(rowIndex, 7).setNumber(typesCount.toDouble());
    sheet.getRangeByIndex(rowIndex, 8).setNumber(g.totalArea / 10000);

    totalWidth += displayWidth;
    totalHeight += displayHeight;
    totalArea += displayArea;
    itemsCount += typesCount;
    totalQtyUsed += g.totalQty;
    totalAreaDiv += g.totalArea / 10000;

    rowIndex++;
  }

  rowIndex++;

  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 3).setNumber(groups.length.toDouble());
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalHeight);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalArea);
  sheet.getRangeByIndex(rowIndex, 6).setNumber(totalQtyUsed.toDouble());
  sheet.getRangeByIndex(rowIndex, 7).setNumber(itemsCount.toDouble());
  sheet.getRangeByIndex(rowIndex, 8).setNumber(totalAreaDiv);
}
