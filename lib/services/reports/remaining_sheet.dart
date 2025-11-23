import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/carpet.dart';

void createRemainingSheet(Workbook workbook, List<Carpet> remaining) {
  final Worksheet sheet = workbook.worksheets.addWithName('المتبقي');

  List<String> headers = [
    'معرف السجادة',
    'أمر العيل',
    'العرض',
    'الطول',
    'الكمية المتبقية',
  ];

  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  Map<String, int> aggregated = {};

  for (var r in remaining) {
    if (r.remQty > 0) {
      if (r.repeated.isNotEmpty) {
        for (var rep in r.repeated) {
          if ((rep['qty_rem'] as int) > 0) {
            String key = "${rep['id']}|${r.width}|${r.height}|${rep['client_order']}";
            aggregated[key] = (aggregated[key] ?? 0) + (rep['qty_rem'] as int);
          }
        }
      } else {
        if (r.remQty > 0) {
          String key = "${r.id}|${r.width}|${r.height}|${r.clientOrder}";
          aggregated[key] = (aggregated[key] ?? 0) + r.remQty;
        }
      }
    }
  }

  int rowIndex = 2;
  double totalWidth = 0;
  double totalHeight = 0;
  int totalRemQty = 0;

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

    totalWidth += w;
    totalHeight += h;
    totalRemQty += qty;

    rowIndex++;
  });

  rowIndex++;

  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setText('');
  sheet.getRangeByIndex(rowIndex, 3).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalHeight);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalRemQty.toDouble());
}
