import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/group_carpet.dart';

void createGroupDetailsSheet(Workbook workbook, List<GroupCarpet> groups) {
  final Worksheet sheet = workbook.worksheets.addWithName('تفاصيل القصات');
  
  // Headers
  List<String> headers = [
    'رقم القصة',
    'امر العميل',
    'معرف السجاد',
    'العرض',
    'الطول',
    'رقم المسار',
    'الكمية المستخدمة',
    'طول المسار',
    'الكمية الاصلية',
    'الكمية المتبقية',
  ];

  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  int rowIndex = 2;
  int groupId = 0;
  
  double totalWidth = 0;
  double totalHeight = 0;
  int totalQtyUsed = 0;
  int totalLengthRef = 0;
  int totalQty = 0;
  int totalQtyRem = 0;

  for (var g in groups) {
    groupId++;
    int pathNum = 0;
    
    for (var item in g.items) {
      pathNum++;
      
      if (item.repeated.isNotEmpty) {
        int refLength = 0;
        for (var rep in item.repeated) {
          refLength += (rep['qty'] as int) * item.height;
          
          sheet.getRangeByIndex(rowIndex, 1).setText('القصة_$groupId');
          sheet.getRangeByIndex(rowIndex, 2).setNumber((rep['client_order'] as int).toDouble());
          sheet.getRangeByIndex(rowIndex, 3).setNumber(item.carpetId.toDouble());
          sheet.getRangeByIndex(rowIndex, 4).setNumber(item.width.toDouble());
          sheet.getRangeByIndex(rowIndex, 5).setNumber(item.height.toDouble());
          sheet.getRangeByIndex(rowIndex, 6).setText('المسار_$pathNum');
          sheet.getRangeByIndex(rowIndex, 7).setNumber((rep['qty'] as int).toDouble());
          sheet.getRangeByIndex(rowIndex, 8).setNumber(refLength.toDouble()); // Note: logic in python accumulates refLength inside loop but writes it each time? Python: ref_lenth+=... rows.append(..., ref_lenth, ...) -> Yes, it writes cumulative length? Or is it just length of this rep? 
          // Python: ref_lenth+= rep.get('qty') * it.height. 
          // It seems it writes the cumulative length up to that point? Or maybe it meant to be just for this item?
          // Let's stick to python logic: ref_lenth is accumulated.
          
          sheet.getRangeByIndex(rowIndex, 9).setNumber((rep['qty_original'] as int).toDouble());
          sheet.getRangeByIndex(rowIndex, 10).setNumber((rep['qty_rem'] as int).toDouble());
          
          rowIndex++;
        }
      } else {
        sheet.getRangeByIndex(rowIndex, 1).setText('القصة_$groupId');
        sheet.getRangeByIndex(rowIndex, 2).setNumber(item.clientOrder.toDouble());
        sheet.getRangeByIndex(rowIndex, 3).setNumber(item.carpetId.toDouble());
        sheet.getRangeByIndex(rowIndex, 4).setNumber(item.width.toDouble());
        sheet.getRangeByIndex(rowIndex, 5).setNumber(item.height.toDouble());
        sheet.getRangeByIndex(rowIndex, 6).setText('المسار_$pathNum');
        sheet.getRangeByIndex(rowIndex, 7).setNumber(item.qtyUsed.toDouble());
        sheet.getRangeByIndex(rowIndex, 8).setNumber(item.lengthRef.toDouble());
        sheet.getRangeByIndex(rowIndex, 9).setNumber((item.qtyUsed + item.qtyRem).toDouble());
        sheet.getRangeByIndex(rowIndex, 10).setNumber(item.qtyRem.toDouble());
        
        rowIndex++;
      }
      
      totalQty += item.qtyUsed + item.qtyRem;
      totalQtyRem += item.qtyRem;
    }
    
    totalWidth += g.totalWidth;
    totalHeight += g.totalHeight;
    totalQtyUsed += g.totalQty;
    totalLengthRef += g.totalLengthRef;
  }
  
  // Empty row
  rowIndex++;
  
  // Totals row
  sheet.getRangeByIndex(rowIndex, 1).setText('');
  sheet.getRangeByIndex(rowIndex, 2).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 3).setText('');
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalHeight);
  sheet.getRangeByIndex(rowIndex, 6).setText('');
  sheet.getRangeByIndex(rowIndex, 7).setNumber(totalQtyUsed.toDouble());
  sheet.getRangeByIndex(rowIndex, 8).setNumber(totalLengthRef.toDouble());
  sheet.getRangeByIndex(rowIndex, 9).setNumber(totalQty.toDouble());
  sheet.getRangeByIndex(rowIndex, 10).setNumber(totalQtyRem.toDouble());
}
