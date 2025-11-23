import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/group_carpet.dart';

void createWasteSheet(Workbook workbook, List<GroupCarpet> groups, int maxWidth) {
  final Worksheet sheet = workbook.worksheets.addWithName('الهادر');

  List<String> headers = [
    'رقم القصة',
    'العرض الإجمالي',
    'الهادر في العرض',
    'اطول مسار',
    'نتيجة الضرب',
    'الهادر في المسارات',
    'نتيجة الجمع',
    'مجموع هادرالمسارات في المجموعة',
  ];

  for (int i = 0; i < headers.length; i++) {
    sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
  }

  int rowIndex = 2;
  int groupId = 0;

  double totalWidth = 0;
  double totalWasteWidth = 0;
  double totalPathLoss = 0;
  double totalMaxPath = 0;
  double totalWasteMaxPath = 0;
  double totalSumPathLoss = 0;
  double totalResult = 0;

  for (var g in groups) {
    groupId++;
    double sumPathLoss = 0;
    
    for (var item in g.items) {
      sumPathLoss += g.maxLengthRef - item.lengthRef;
    }

    double wasteWidth = maxWidth - g.totalWidth.toDouble();
    double pathLoss = (g.maxLengthRef - g.minLengthRef).toDouble();

    sheet.getRangeByIndex(rowIndex, 1).setText('القصة_$groupId');
    sheet.getRangeByIndex(rowIndex, 2).setNumber(g.totalWidth.toDouble());
    sheet.getRangeByIndex(rowIndex, 3).setNumber(wasteWidth);
    sheet.getRangeByIndex(rowIndex, 4).setNumber(g.maxLengthRef.toDouble());
    sheet.getRangeByIndex(rowIndex, 5).setNumber(wasteWidth * g.maxLengthRef);
    sheet.getRangeByIndex(rowIndex, 6).setNumber(pathLoss);
    sheet.getRangeByIndex(rowIndex, 7).setNumber(wasteWidth * g.maxLengthRef + pathLoss);
    sheet.getRangeByIndex(rowIndex, 8).setNumber(sumPathLoss);

    totalWidth += g.totalWidth;
    totalWasteWidth += wasteWidth;
    totalWasteMaxPath += wasteWidth * g.maxLengthRef;
    totalPathLoss += pathLoss;
    totalSumPathLoss += sumPathLoss;
    totalResult += pathLoss * wasteWidth; // Wait, python code: total_result+= pathLoss * wasteWidth. But row calculation is wasteWidth * g.max_length_ref() + pathLoss.
    // Python code:
    // 'نتيجة الجمع': wasteWidth * g.max_length_ref() + pathLoss,
    // total_result+= pathLoss * wasteWidth
    // This seems inconsistent in python code variable naming vs usage?
    // Let's check python code again.
    // total_result+= pathLoss * wasteWidth
    // But the column 'نتيجة الجمع' is wasteWidth * g.max_length_ref() + pathLoss.
    // I will follow the python code logic exactly even if it looks weird.
    
    totalMaxPath += g.maxLengthRef;

    rowIndex++;
  }

  rowIndex++;
  
  sheet.getRangeByIndex(rowIndex, 1).setText('المجموع');
  sheet.getRangeByIndex(rowIndex, 2).setNumber(totalWidth);
  sheet.getRangeByIndex(rowIndex, 3).setNumber(totalWasteWidth);
  sheet.getRangeByIndex(rowIndex, 4).setNumber(totalMaxPath);
  sheet.getRangeByIndex(rowIndex, 5).setNumber(totalWasteMaxPath);
  sheet.getRangeByIndex(rowIndex, 6).setNumber(totalPathLoss);
  sheet.getRangeByIndex(rowIndex, 7).setNumber(totalResult);
  sheet.getRangeByIndex(rowIndex, 8).setNumber(totalSumPathLoss);
}
