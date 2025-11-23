import 'dart:io';
import 'dart:math';
import 'package:excel/excel.dart';
import '../models/carpet.dart';

class ExcelService {
  Future<List<Carpet>> readInputExcel(String path) async {
    if (!File(path).existsSync()) {
      throw FileSystemException("File not found", path);
    }

    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    if (excel.tables.isEmpty) {
      throw Exception("Excel file is empty");
    }

    // Use the first table found
    var table = excel.tables[excel.tables.keys.first]!;
    
    List<Carpet> carpets = [];
    List<int> invalidRows = [];
    
    Map<String, int> prepOffset = {"A": 8, "B": 6, "C": 1, "D": 3};

    // Assuming no header or header is handled by caller? 
    // Python code: header=None. So it reads from first row.
    // Excel package reads all rows.
    
    for (int i = 0; i < table.rows.length; i++) {
      var row = table.rows[i];
      if (row.isEmpty) continue;

      try {
        // Helper to safely get cell value
        dynamic getValue(int index) {
          if (index >= row.length) return null;
          return row[index]?.value;
        }

        var col0 = getValue(0); // Client Order
        var col1 = getValue(1); // Width
        var col2 = getValue(2); // Height
        var col3 = getValue(3); // Qty
        var col4 = getValue(4); // Single/Pair
        var col5 = getValue(5); // Texture Type
        var col6 = getValue(6); // Prep Code

        if (col0 == null || col1 == null || col2 == null || col3 == null) {
           // Skip empty or incomplete rows
           continue;
        }

        int clientOrder = int.parse(col0.toString());
        int width = int.parse(col1.toString().trim());
        int height = int.parse(col2.toString().trim());
        int qtyRaw = int.parse(col3.toString());
        
        String singlePair = col4?.toString().trim().toUpperCase() ?? "";
        String textureType = col5?.toString().trim().toUpperCase() ?? "";
        String prepCode = col6?.toString().trim().toUpperCase() ?? "";

        int qty = qtyRaw;
        if (singlePair == "A") {
          qty = max(1, qtyRaw ~/ 2);
        }

        if (prepOffset.containsKey(prepCode)) {
          height += prepOffset[prepCode]!;
        }

        if (textureType == "B") {
          int temp = width;
          width = height;
          height = temp;
        }

        if (width <= 0 || height <= 0 || qty <= 0) {
          invalidRows.add(i + 1);
          continue;
        }

        carpets.add(Carpet(
          id: i + 1,
          width: width,
          height: height,
          qty: qty,
          clientOrder: clientOrder,
        ));

      } catch (e) {
        invalidRows.add(i + 1);
        continue;
      }
    }

    return carpets;
  }
}
