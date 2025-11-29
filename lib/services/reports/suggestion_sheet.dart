import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import 'dart:math';

void createRemainingSuggestionSheet(
  Workbook workbook,
  List<Carpet> remaining,
  int minWidth,
  int maxWidth,
  int tolerance,
) {
  final Worksheet sheet = workbook.worksheets.addWithName('اقتراحات المتبقيات');

  List<String> headers = [
    'معرف السجادة',
    'أمر العميل',
    'العرض',
    'الطول',
    'الكمية المتبقية',
    'اقل عرض مجموعة',
    'أعلى عرض مجموعة',
    'اقل طول مرجعي',
    'اكبر طول مرجعي',
  ];

  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  Map<String, int> aggregated = {};
  for (var r in remaining) {
    if (r.remQty > 0) {
      String key = "${r.id}|${r.width}|${r.height}|${r.clientOrder}";
      aggregated[key] = (aggregated[key] ?? 0) + r.remQty;
    }
  }

  int rowIndex = 2;
  double totalWidth = 0;
  double totalHeight = 0;
  int totalRemQty = 0;
  double totalMissingMinWidth = 0;
  double totalMissingMaxWidth = 0;
  double totalMinHeightRef = 0;
  double totalMaxHeightRef = 0;

  aggregated.forEach((key, qty) {
    var parts = key.split('|');
    int rid = int.parse(parts[0]);
    int w = int.parse(parts[1]);
    int h = int.parse(parts[2]);
    int co = int.parse(parts[3]);

    sheet.getRangeByIndex(rowIndex, 1).setNumber(rid.toDouble());
    sheet.getRangeByIndex(rowIndex, 2).setNumber(co.toDouble());
    sheet.getRangeByIndex(rowIndex, 3).setNumber(w.toDouble());
    sheet.getRangeByIndex(rowIndex, 4).setNumber(h.toDouble());
    sheet.getRangeByIndex(rowIndex, 5).setNumber(qty.toDouble());
    sheet.getRangeByIndex(rowIndex, 6).setNumber((minWidth - w).toDouble());
    sheet.getRangeByIndex(rowIndex, 7).setNumber((maxWidth - w).toDouble());
    sheet
        .getRangeByIndex(rowIndex, 8)
        .setNumber((h * qty - tolerance).toDouble());
    sheet
        .getRangeByIndex(rowIndex, 9)
        .setNumber((h * qty + tolerance).toDouble());

    totalWidth += w;
    totalHeight += h;
    totalRemQty += qty;
    totalMissingMinWidth += minWidth - w;
    totalMissingMaxWidth += maxWidth - w;
    totalMinHeightRef += h * qty - tolerance;
    totalMaxHeightRef += h * qty + tolerance;

    rowIndex++;
  });

  rowIndex++;
  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setText('');
  sheet.getRangeByIndex(rowIndex, 3).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalHeight);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalRemQty.toDouble());
  sheet.getRangeByIndex(rowIndex, 6).setNumber(totalMissingMinWidth);
  sheet.getRangeByIndex(rowIndex, 7).setNumber(totalMissingMaxWidth);
  sheet.getRangeByIndex(rowIndex, 8).setNumber(totalMinHeightRef);
  sheet.getRangeByIndex(rowIndex, 9).setNumber(totalMaxHeightRef);
}

void createEnhancedRemainingSuggestionSheet(
  Workbook workbook,
  List<List<GroupCarpet>>? suggestedGroups,
  int minWidth,
  int maxWidth,
  int tolerance,
) {
  final Worksheet sheet = workbook.worksheets.addWithName(
    'اقتراحات المتبقيات المحسنة',
  );

  List<String> headers = [
    'الاقتراح',
    'معرف السجادة',
    'أمر العميل',
    'العرض',
    'الطول',
    'الكمية المستخدمة',
    'الكمية المتبقية',
    'اقل عرض مجموعة مسموح',
    'أكبر عرض مجموعة مسموح',
    'اقل طول مسار',
    'اكبر طول مسار',
  ];

  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  if (suggestedGroups == null) return;

  int rowIndex = 2;
  int suggestedId = 0;
  double totalWidth = 0;
  double totalHeight = 0;
  int totalCarpetUsed = 0;
  int totalCarpetRem = 0;
  double totalLocalMinWidth = 0;
  double totalLocalMaxWidth = 0;
  double totalLocalMinTolerance = 0;
  double totalLocalMaxTolerance = 0;

  for (var carpetGroups in suggestedGroups) {
    suggestedId++;
    for (var group in carpetGroups) {
      double localMinWidth = (minWidth - group.totalWidth) > 0
          ? (minWidth - group.totalWidth).toDouble()
          : 0;
      double localMaxWidth = (maxWidth - group.totalWidth).toDouble();

      int maxLenRef = 0;
      if (group.items.isNotEmpty) {
        maxLenRef = group.items.map((i) => i.lengthRef).reduce(max);
      }

      double localMinTolerance = (maxLenRef - tolerance).toDouble();
      double localMaxTolerance = (maxLenRef + tolerance).toDouble();

      totalWidth += group.totalWidth;
      totalHeight += group.totalHeight;
      totalCarpetUsed += group.totalQty;
      totalCarpetRem += group.totalRemQty;
      totalLocalMinWidth += localMinWidth;
      totalLocalMaxWidth += localMaxWidth;
      totalLocalMinTolerance += localMinTolerance;
      totalLocalMaxTolerance += localMaxTolerance;

      for (var item in group.items) {
        if (item.repeated.isNotEmpty) {
          for (var rep in item.repeated) {
            sheet.getRangeByIndex(rowIndex, 1).setText('الاقتراح_$suggestedId');
            sheet
                .getRangeByIndex(rowIndex, 2)
                .setNumber(item.carpetId.toDouble());
            sheet
                .getRangeByIndex(rowIndex, 3)
                .setNumber((rep['client_order'] as int).toDouble());
            sheet.getRangeByIndex(rowIndex, 4).setNumber(item.width.toDouble());
            sheet
                .getRangeByIndex(rowIndex, 5)
                .setNumber(item.height.toDouble());
            sheet
                .getRangeByIndex(rowIndex, 6)
                .setNumber((rep['qty'] as int).toDouble());
            sheet
                .getRangeByIndex(rowIndex, 7)
                .setNumber((rep['qty_rem'] as int).toDouble());
            sheet.getRangeByIndex(rowIndex, 8).setNumber(localMinWidth);
            sheet.getRangeByIndex(rowIndex, 9).setNumber(localMaxWidth);
            sheet.getRangeByIndex(rowIndex, 10).setNumber(localMinTolerance);
            sheet.getRangeByIndex(rowIndex, 11).setNumber(localMaxTolerance);
            rowIndex++;
          }
        } else {
          sheet.getRangeByIndex(rowIndex, 1).setText('الاقتراح_$suggestedId');
          sheet
              .getRangeByIndex(rowIndex, 2)
              .setNumber(item.carpetId.toDouble());
          sheet
              .getRangeByIndex(rowIndex, 3)
              .setNumber(item.clientOrder.toDouble());
          sheet.getRangeByIndex(rowIndex, 4).setNumber(item.width.toDouble());
          sheet.getRangeByIndex(rowIndex, 5).setNumber(item.height.toDouble());
          sheet.getRangeByIndex(rowIndex, 6).setNumber(item.qtyUsed.toDouble());
          sheet.getRangeByIndex(rowIndex, 7).setNumber(item.qtyRem.toDouble());
          sheet.getRangeByIndex(rowIndex, 8).setNumber(localMinWidth);
          sheet.getRangeByIndex(rowIndex, 9).setNumber(localMaxWidth);
          sheet.getRangeByIndex(rowIndex, 10).setNumber(localMinTolerance);
          sheet.getRangeByIndex(rowIndex, 11).setNumber(localMaxTolerance);
          rowIndex++;
        }
      }
    }
    rowIndex++; // Empty row separator
  }

  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setText('');
  sheet.getRangeByIndex(rowIndex, 3).setText('');
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalHeight);
  sheet.getRangeByIndex(rowIndex, 6).setNumber(totalCarpetUsed.toDouble());
  sheet.getRangeByIndex(rowIndex, 7).setNumber(totalCarpetRem.toDouble());
  sheet.getRangeByIndex(rowIndex, 8).setNumber(totalLocalMinWidth);
  sheet.getRangeByIndex(rowIndex, 9).setNumber(totalLocalMaxWidth);
  sheet.getRangeByIndex(rowIndex, 10).setNumber(totalLocalMinTolerance);
  sheet.getRangeByIndex(rowIndex, 11).setNumber(totalLocalMaxTolerance);
}
