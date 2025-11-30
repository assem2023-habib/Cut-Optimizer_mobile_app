import '../models/group_carpet.dart';
import '../models/carpet.dart';

/// Helper class لحساب الإحصائيات من نتائج المعالجة
class ResultsCalculator {
  ResultsCalculator._();

  /// حساب المساحة الكلية لجميع السجاد الأصلي
  static double calculateTotalArea(
    List<GroupCarpet> groups,
    List<Carpet> remaining,
  ) {
    double total = 0;

    // مساحة المجموعات (من items داخل كل GroupCarpet)
    for (var group in groups) {
      for (var item in group.items) {
        // CarpetUsed has qtyUsed and area
        total += (item.area * item.qtyUsed) / 10000; // تحويل من سم² إلى م²
      }
    }

    // مساحة المتبقي (Carpet)
    for (var carpet in remaining) {
      total += (carpet.area * carpet.remQty) / 10000;
    }

    return total;
  }

  /// حساب المساحة المستخدمة (في المجموعات فقط)
  static double calculateUsedArea(List<GroupCarpet> groups) {
    double used = 0;

    for (var group in groups) {
      for (var item in group.items) {
        used += (item.area * item.qtyUsed) / 10000;
      }
    }

    return used;
  }

  /// حساب مساحة الهادر (المتبقية)
  static double calculateWasteArea(
    List<GroupCarpet> groups,
    List<Carpet> remaining,
  ) {
    double wasteArea = 0;

    for (var carpet in remaining) {
      wasteArea += (carpet.area * carpet.remQty) / 10000;
    }

    return wasteArea;
  }

  /// حساب نسبة الكفاءة
  static double calculateEfficiency(
    List<GroupCarpet> groups,
    List<Carpet> remaining,
  ) {
    double totalArea = calculateTotalArea(groups, remaining);
    if (totalArea == 0) return 0;

    double usedArea = calculateUsedArea(groups);
    return (usedArea / totalArea) * 100;
  }

  /// حساب نسبة الهادر
  static double calculateWastePercentage(
    List<GroupCarpet> groups,
    List<Carpet> remaining,
  ) {
    double totalArea = calculateTotalArea(groups, remaining);
    if (totalArea == 0) return 0;

    double wasteArea = calculateWasteArea(groups, remaining);
    return (wasteArea / totalArea) * 100;
  }

  /// حساب عدد القصات الفريدة
  static int calculateUniqueCuts(List<GroupCarpet> groups) {
    // In current logic, each group is a cut. If we group identicals, this might change.
    return groups.length;
  }

  /// حساب إجمالي عدد المجموعات
  static int calculateTotalGroups(List<GroupCarpet> groups) {
    return groups.fold<int>(0, (sum, group) => sum + group.repetitions);
  }

  /// حساب إجمالي عدد القطع في مجموعة
  static int getPiecesCountInGroup(GroupCarpet group) {
    return group.totalQty;
  }

  /// حساب إجمالي الطول/العرض
  static int getGroupWidth(GroupCarpet group) {
    return group.totalWidth;
  }

  static int getGroupHeight(GroupCarpet group) {
    return group.maxHeight;
  }

  /// حساب المساحة الأصلية الكلية (قبل القص) - من السجاد الأصلي
  /// This matches the logic in waste_sheet.dart for totalOriginal calculation
  static double calculateTotalOriginalArea(
    List<Carpet>? originals,
    List<GroupCarpet> groups,
  ) {
    double totalOriginal = 0;
    if (originals != null && originals.isNotEmpty) {
      // Use original carpet data
      for (var carpet in originals) {
        totalOriginal += carpet.area * carpet.qty;
      }
    } else {
      // Fallback: calculate from groups if originals not available
      for (var group in groups) {
        for (var carpet in group.items) {
          totalOriginal += carpet.area * (carpet.qtyUsed + carpet.qtyRem);
        }
      }
    }
    return totalOriginal;
  }

  /// حساب هادر المسارات لمجموعة واحدة (matching waste_sheet.dart logic)
  /// Calculates path waste for a single group including width waste
  static double calculatePathWasteForGroup(GroupCarpet group, int maxWidth) {
    // Waste in width = maxWidth - totalWidth of group
    double wasteWidth = (maxWidth - group.totalWidth).toDouble();

    // Max path (reference path) = longest path in the group
    int maxPath = group.maxLengthRef;

    // Path waste = sum of (maxPath - itemPath) * itemWidth for all items
    double pathWaste = 0;
    for (var item in group.items) {
      pathWaste += (maxPath - item.lengthRef) * item.width;
    }

    // Add width waste area to path waste
    pathWaste += wasteWidth * maxPath;

    return pathWaste;
  }

  /// حساب نسبة الهادر الصحيحة (matching waste_sheet.dart logic)
  /// Uses totalOriginal as denominator instead of totalArea
  static double calculateCorrectWastePercentage(
    List<GroupCarpet> groups,
    List<Carpet>? originals,
    int maxWidth,
  ) {
    double totalOriginal = calculateTotalOriginalArea(originals, groups);
    if (totalOriginal == 0) return 0;

    double totalPathWaste = 0;
    for (var group in groups) {
      totalPathWaste += calculatePathWasteForGroup(group, maxWidth);
    }

    return (totalPathWaste / totalOriginal) * 100;
  }

  /// تحويل index إلى لون HEX (للعرض)
  static String getColorForGroup(int index) {
    final colors = [
      '#3B82F6', // blue
      '#10B981', // green
      '#F59E0B', // orange
      '#8B5CF6', // purple
      '#EC4899', // pink
      '#06B6D4', // cyan
      '#F43F5E', // rose
      '#84CC16', // lime
      '#EAB308', // yellow
      '#14B8A6', // teal
    ];
    return colors[index % colors.length];
  }
}
