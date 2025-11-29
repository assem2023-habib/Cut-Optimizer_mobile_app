import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/group_carpet.dart';

void createGroupSummarySheet(Workbook workbook, List<GroupCarpet> groups) {
  final Worksheet sheet = workbook.worksheets.addWithName('ملخص القصات');

  List<String> headers = [
    'رقم القصة',
    'العرض الإجمالي',
    'عدد المسارات',
    'أقصى ارتفاع',
    'المساحة الإجمالية',
    'الكمية المستخدمة الكلية',
    'عدد أنواع السجاد',
    'المساحة الإجمالية_2',
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

    sheet.getRangeByIndex(rowIndex, 1).setText('القصة_$groupId');
    sheet.getRangeByIndex(rowIndex, 2).setNumber(g.totalWidth.toDouble());
    sheet.getRangeByIndex(rowIndex, 3).setNumber(g.items.length.toDouble());
    sheet.getRangeByIndex(rowIndex, 4).setNumber(g.maxHeight.toDouble());
    sheet.getRangeByIndex(rowIndex, 5).setNumber(g.totalArea.toDouble());
    sheet.getRangeByIndex(rowIndex, 6).setNumber(g.totalQty.toDouble());
    sheet.getRangeByIndex(rowIndex, 7).setNumber(typesCount.toDouble());
    sheet.getRangeByIndex(rowIndex, 8).setNumber(g.totalArea / 10000);

    totalWidth += g.totalWidth;
    totalHeight += g.maxHeight;
    totalArea += g.totalArea;
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
