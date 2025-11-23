import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/carpet.dart';
import '../../models/group_carpet.dart';

void createAuditSheet(Workbook workbook, List<GroupCarpet> groups, List<Carpet> remaining, List<Carpet>? originals) {
  final Worksheet sheet = workbook.worksheets.addWithName('تدقيق');

  List<String> headers = [
    'معرف السجادة',
    'أمر العميل',
    'العرض',
    'الارتفاع',
    'الكمية الأصلية',
    'الكمية المستخدمة',
    'الكمية المتبقية',
    'فارق (المستخدم+المتبقي-الأصلي)',
    'مطابق؟',
  ];

  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  Map<String, int> usedTotals = {};
  
  for (var g in groups) {
    for (var it in g.items) {
      if (it.repeated.isNotEmpty) {
        for (var rep in it.repeated) {
          String key = "${rep['id']}|${it.width}|${it.height}|${rep['client_order']}";
          usedTotals[key] = (usedTotals[key] ?? 0) + (rep['qty'] as int);
        }
      } else {
        String key = "${it.carpetId}|${it.width}|${it.height}|${it.clientOrder}";
        usedTotals[key] = (usedTotals[key] ?? 0) + it.qtyUsed;
      }
    }
  }

  Map<String, int> remainingTotals = {};
  for (var r in remaining) {
    if (r.repeated.isNotEmpty) {
      for (var rep in r.repeated) {
        if ((rep['qty_rem'] as int) > 0) {
          String key = "${rep['id']}|${r.width}|${r.height}|${rep['client_order']}";
          remainingTotals[key] = (remainingTotals[key] ?? 0) + (rep['qty_rem'] as int);
        }
      }
    } else {
      if (r.remQty > 0) {
        String key = "${r.id}|${r.width}|${r.height}|${r.clientOrder}";
        remainingTotals[key] = (remainingTotals[key] ?? 0) + r.remQty;
      }
    }
  }

  Map<String, int> originalTotals = {};
  if (originals != null) {
    for (var r in originals) {
      String key = "${r.id}|${r.width}|${r.height}|${r.clientOrder}";
      originalTotals[key] = (originalTotals[key] ?? 0) + r.qty;
    }
  } else {
    Set<String> allKeys = {...usedTotals.keys, ...remainingTotals.keys};
    for (var k in allKeys) {
      originalTotals[k] = (usedTotals[k] ?? 0) + (remainingTotals[k] ?? 0);
    }
  }

  Set<String> allKeys = {...originalTotals.keys, ...usedTotals.keys, ...remainingTotals.keys};
  List<String> sortedKeys = allKeys.toList();
  // Sort logic similar to python: id, width, height
  sortedKeys.sort((a, b) {
    var partsA = a.split('|');
    var partsB = b.split('|');
    int idA = int.parse(partsA[0]);
    int idB = int.parse(partsB[0]);
    if (idA != idB) return idA.compareTo(idB);
    
    int wA = int.parse(partsA[1]);
    int wB = int.parse(partsB[1]);
    if (wA != wB) return wA.compareTo(wB);
    
    int hA = int.parse(partsA[2]);
    int hB = int.parse(partsB[2]);
    return hA.compareTo(hB);
  });

  int rowIndex = 2;
  double totalWidth = 0;
  double totalHeight = 0;
  int totalOriginalQty = 0;
  int totalUsedQty = 0;
  int totalRemQty = 0;
  int totalDiffQty = 0;

  for (var key in sortedKeys) {
    var parts = key.split('|');
    int rid = int.parse(parts[0]);
    int w = int.parse(parts[1]);
    int h = int.parse(parts[2]);
    int co = int.parse(parts[3]);

    int orig = originalTotals[key] ?? 0;
    int used = usedTotals[key] ?? 0;
    int rem = remainingTotals[key] ?? 0;
    int diff = used + rem - orig;

    totalWidth += w;
    totalHeight += h;
    totalOriginalQty += orig;
    totalUsedQty += used;
    totalRemQty += rem;
    totalDiffQty += diff;

    sheet.getRangeByIndex(rowIndex, 1).setNumber(rid.toDouble());
    sheet.getRangeByIndex(rowIndex, 2).setNumber(co.toDouble());
    sheet.getRangeByIndex(rowIndex, 3).setNumber(w.toDouble());
    sheet.getRangeByIndex(rowIndex, 4).setNumber(h.toDouble());
    sheet.getRangeByIndex(rowIndex, 5).setNumber(orig.toDouble());
    sheet.getRangeByIndex(rowIndex, 6).setNumber(used.toDouble());
    sheet.getRangeByIndex(rowIndex, 7).setNumber(rem.toDouble());
    sheet.getRangeByIndex(rowIndex, 8).setNumber(diff.toDouble());
    sheet.getRangeByIndex(rowIndex, 9).setText(diff == 0 ? '✅ نعم' : '❌ لا');

    rowIndex++;
  }

  rowIndex++;
  String isSame = totalOriginalQty == totalUsedQty + totalRemQty ? '✅ نعم' : '❌ لا';

  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setText('');
  sheet.getRangeByIndex(rowIndex, 3).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalHeight);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalOriginalQty.toDouble());
  sheet.getRangeByIndex(rowIndex, 6).setNumber(totalUsedQty.toDouble());
  sheet.getRangeByIndex(rowIndex, 7).setNumber(totalRemQty.toDouble());
  sheet.getRangeByIndex(rowIndex, 8).setNumber(totalDiffQty.toDouble());
  sheet.getRangeByIndex(rowIndex, 9).setText(isSame);
}
