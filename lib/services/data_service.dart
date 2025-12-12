import '../models/carpet.dart';
import '../models/config.dart';
import '../models/group_carpet.dart';
import 'excel_service.dart';
import 'report_service.dart';

class DataService {
  final ExcelService _excelService = ExcelService();
  final ReportService _reportService = ReportService();

  Future<List<Carpet>> readInputExcel(String path, {PairOddMode? pairOddMode}) async {
    return await _excelService.readInputExcel(path, pairOddMode: pairOddMode);
  }

  Future<void> writeOutputExcel({
    required String path,
    required List<GroupCarpet> groups,
    required List<Carpet> remaining,
    int? minWidth,
    int? maxWidth,
    int? toleranceLength,
    List<Carpet>? originals,
    List<List<GroupCarpet>>? suggestedGroups,
    required MeasurementUnit measurementUnit,
    int pathLength = 0,
  }) async {
    await _reportService.generateReport(
      groups: groups,
      remaining: remaining,
      minWidth: minWidth ?? 0,
      maxWidth: maxWidth ?? 0,
      tolerance: toleranceLength ?? 0,
      outputPath: path,
      originalGroups: originals,
      suggestedGroups: suggestedGroups,
      measurementUnit: measurementUnit,
      pathLength: pathLength,
    );
  }
}
