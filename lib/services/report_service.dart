import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import 'reports/group_details_sheet.dart';
import 'reports/group_summary_sheet.dart';
import 'reports/remaining_sheet.dart';
import 'reports/totals_sheet.dart';
import 'reports/audit_sheet.dart';
import 'reports/waste_sheet.dart';
import 'reports/suggestion_sheet.dart';
import 'report_formatting.dart';

class ReportService {
  Future<void> generateReport({
    required List<GroupCarpet> groups,
    required List<Carpet> remaining,
    required int minWidth,
    required int maxWidth,
    required int tolerance,
    required String outputPath,
    List<Carpet>? originalGroups,
    List<List<GroupCarpet>>? suggestedGroups,
  }) async {
    final Workbook workbook = Workbook();

    // Remove default sheet if any (usually Sheet1)
    // Syncfusion creates Sheet1 by default. We can clear it or just add ours and remove it later.
    // Or just use it for the first sheet.
    // Let's just add our sheets.

    // 1. Group Details
    createGroupDetailsSheet(workbook, groups);

    // 2. Group Summary
    createGroupSummarySheet(workbook, groups);

    // 3. Remaining
    createRemainingSheet(workbook, remaining);

    // 4. Totals
    createTotalsSheet(workbook, originalGroups, groups, remaining);

    // 5. Audit
    createAuditSheet(workbook, groups, remaining, originalGroups);

    // 6. Waste
    createWasteSheet(workbook, groups, maxWidth);

    // 7. Remaining Suggestions
    createRemainingSuggestionSheet(
      workbook,
      remaining,
      minWidth,
      maxWidth,
      tolerance,
    );

    // 8. Enhanced Suggestions
    if (suggestedGroups != null && suggestedGroups.isNotEmpty) {
      createEnhancedRemainingSuggestionSheet(
        workbook,
        suggestedGroups,
        minWidth,
        maxWidth,
        tolerance,
      );
    }

    // Apply Formatting to all sheets
    for (int i = 0; i < workbook.worksheets.count; i++) {
      Worksheet sheet = workbook.worksheets[i];
      // Skip default sheet if it's empty/unused and we plan to remove it,
      // but since we might not remove it successfully, let's format it if it has data?
      // Actually, applyFormatting checks for usedRange.
      ReportFormatting.applyFormatting(sheet);
    }

    // Remove default Sheet1 if it exists and is empty/unused
    // Note: Syncfusion XlsIO might not expose a direct remove method on the collection in this version
    // or it might be named differently. For now, we skip removing it to avoid compilation errors.
    /*
    try {
        if (workbook.worksheets.count > 0) {
            var sheet1 = workbook.worksheets['Sheet1'];
            if (sheet1 != null) {
                // workbook.worksheets.remove(sheet1); // Not available
            }
        }
    } catch (e) {
        // Ignore
    }
    */

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      final blob = html.Blob([
        bytes,
      ], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = outputPath.split('/').last;
      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      File(outputPath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes);
    }
  }
}
