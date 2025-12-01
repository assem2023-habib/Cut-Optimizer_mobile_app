import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import '../../models/config.dart';
import 'dart:math';

void createRemainingSuggestionSheet(
  Workbook workbook,
  List<Carpet> remaining,
  int minWidth,
  int maxWidth,
  int tolerance,
  MeasurementUnit unit,
) {
  final Worksheet sheet = workbook.worksheets.addWithName('اقتراحات المتبقيات');

  // Helper for conversion
  double convert(num value) {
    if (unit == MeasurementUnit.cm) {
      return value.toDouble();
    } else {
      return value / 100.0;
    }
  }

  String unitLabel = unit == MeasurementUnit.cm ? ' (سم)' : ' (م)';

  List<String> headers = [
    'معرف السجادة',
    'أمر العميل',
    'العرض$unitLabel',
    'الطول$unitLabel',
    'الكمية المتبقية',
    'اقل عرض مجموعة$unitLabel',
    'أعلى عرض مجموعة$unitLabel',
    'اقل طول مرجعي$unitLabel',
    'اكبر طول مرجعي$unitLabel',
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

    double displayWidth = convert(w);
    double displayHeight = convert(h);
    double displayMissingMinWidth = convert(minWidth - w);
    double displayMissingMaxWidth = convert(maxWidth - w);
    double displayMinHeightRef = convert(h * qty - tolerance);
    double displayMaxHeightRef = convert(h * qty + tolerance);

    sheet.getRangeByIndex(rowIndex, 1).setNumber(rid.toDouble());
    sheet.getRangeByIndex(rowIndex, 2).setNumber(co.toDouble());
    sheet.getRangeByIndex(rowIndex, 3).setNumber(displayWidth);
    sheet.getRangeByIndex(rowIndex, 4).setNumber(displayHeight);
    sheet.getRangeByIndex(rowIndex, 5).setNumber(qty.toDouble());
    sheet.getRangeByIndex(rowIndex, 6).setNumber(displayMissingMinWidth);
    sheet.getRangeByIndex(rowIndex, 7).setNumber(displayMissingMaxWidth);
    sheet.getRangeByIndex(rowIndex, 8).setNumber(displayMinHeightRef);
    sheet.getRangeByIndex(rowIndex, 9).setNumber(displayMaxHeightRef);

    totalWidth += displayWidth;
    totalHeight += displayHeight;
    totalRemQty += qty;
    totalMissingMinWidth += displayMissingMinWidth;
    totalMissingMaxWidth += displayMissingMaxWidth;
    totalMinHeightRef += displayMinHeightRef;
    totalMaxHeightRef += displayMaxHeightRef;

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
  MeasurementUnit unit,
) {
  final Worksheet sheet = workbook.worksheets.addWithName(
    'اقتراحات المتبقيات المحسنة',
  );

  // Helper for conversion
  double convert(num value) {
    if (unit == MeasurementUnit.cm) {
      return value.toDouble();
    } else {
      return value / 100.0;
    }
  }

  String unitLabel = unit == MeasurementUnit.cm ? ' (سم)' : ' (م)';

  List<String> headers = [
    'الاقتراح',
    'معرف السجادة',
    'أمر العميل',
    'العرض$unitLabel',
    'الطول$unitLabel',
    'الكمية المستخدمة',
    'الكمية المتبقية',
    'اقل عرض مجموعة مسموح$unitLabel',
    'أكبر عرض مجموعة مسموح$unitLabel',
    'اقل طول مسار$unitLabel',
    'اكبر طول مسار$unitLabel',
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

      double displayWidth = convert(group.totalWidth);
      double displayHeight = convert(group.totalHeight);
      double displayLocalMinWidth = convert(localMinWidth);
      double displayLocalMaxWidth = convert(localMaxWidth);
      double displayLocalMinTolerance = convert(localMinTolerance);
      double displayLocalMaxTolerance = convert(localMaxTolerance);

      totalWidth += displayWidth;
      totalHeight += displayHeight;
      totalCarpetUsed += group.totalQty;
      totalCarpetRem += group.totalRemQty;
      totalLocalMinWidth += displayLocalMinWidth;
      totalLocalMaxWidth += displayLocalMaxWidth;
      totalLocalMinTolerance += displayLocalMinTolerance;
      totalLocalMaxTolerance += displayLocalMaxTolerance;

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
            sheet.getRangeByIndex(rowIndex, 4).setNumber(convert(item.width));
            sheet.getRangeByIndex(rowIndex, 5).setNumber(convert(item.height));
            sheet
                .getRangeByIndex(rowIndex, 6)
                .setNumber((rep['qty'] as int).toDouble());
            sheet
                .getRangeByIndex(rowIndex, 7)
                .setNumber((rep['qty_rem'] as int).toDouble());
            sheet.getRangeByIndex(rowIndex, 8).setNumber(displayLocalMinWidth);
            sheet.getRangeByIndex(rowIndex, 9).setNumber(displayLocalMaxWidth);
            sheet
                .getRangeByIndex(rowIndex, 10)
                .setNumber(displayLocalMinTolerance);
            sheet
                .getRangeByIndex(rowIndex, 11)
                .setNumber(displayLocalMaxTolerance);
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
          sheet.getRangeByIndex(rowIndex, 4).setNumber(convert(item.width));
          sheet.getRangeByIndex(rowIndex, 5).setNumber(convert(item.height));
          sheet.getRangeByIndex(rowIndex, 6).setNumber(item.qtyUsed.toDouble());
          sheet.getRangeByIndex(rowIndex, 7).setNumber(item.qtyRem.toDouble());
          sheet.getRangeByIndex(rowIndex, 8).setNumber(displayLocalMinWidth);
          sheet.getRangeByIndex(rowIndex, 9).setNumber(displayLocalMaxWidth);
          sheet
              .getRangeByIndex(rowIndex, 10)
              .setNumber(displayLocalMinTolerance);
          sheet
              .getRangeByIndex(rowIndex, 11)
              .setNumber(displayLocalMaxTolerance);
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
