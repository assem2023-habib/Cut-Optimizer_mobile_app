import 'dart:math';
import '../../models/carpet.dart';
import '../../models/carpet_used.dart';
import '../../models/group_carpet.dart';
import '../../core/math_utils.dart';
import 'algorithm_models.dart';

class GroupProcessor {
  ProcessResult? processPartnerGroup(
    Carpet main,
    List<Carpet> partners,
    int tolerance,
    int currentGroupId,
    int minWidth,
    int maxWidth,
    int pathLength,
  ) {
    List<Carpet> elements = [main, ...partners];
    Map<int, int> elementsCounts = {};
    for (var e in elements) {
      elementsCounts[e.id] = (elementsCounts[e.id] ?? 0) + 1;
    }

    List<int> a = [];
    List<int> xMax = [];
    List<Carpet> uniqueElements = [];
    Set<int> seen = {};

    for (var e in elements) {
      if (!seen.contains(e.id)) {
        seen.add(e.id);
        uniqueElements.add(e);
        a.add(e.height);

        int repetitionCount = elementsCounts[e.id]!;
        int availablePerRepetition = e.remQty ~/ repetitionCount;
        xMax.add(availablePerRepetition);
      }
    }

    if (xMax.any((x) => x <= 0)) {
      return null;
    }

    EqualProductResult eqResult;
    if (tolerance == 0) {
      eqResult = equalProductsSolution(a, xMax, maxProduct: pathLength);
    } else {
      eqResult = equalProductsSolutionWithTolerance(
        a,
        xMax,
        tolerance,
        maxProduct: pathLength,
      );
    }

    if (eqResult.xList == null || eqResult.kMax <= 0) {
      return null;
    }

    List<int> xVals = eqResult.xList!;
    List<CarpetUsed> usedItems = [];
    bool allValid = true;
    List<Map<String, dynamic>> rollbackData = [];

    for (int i = 0; i < uniqueElements.length; i++) {
      Carpet e = uniqueElements[i];
      int x = xVals[i];

      if (x <= 0) {
        allValid = false;
        break;
      }

      int repetitionCount = elementsCounts[e.id]!;
      int qtyPerRepetition = min(x, e.remQty ~/ repetitionCount);

      if (qtyPerRepetition <= 0) {
        allValid = false;
        break;
      }

      int totalQtyUsed = qtyPerRepetition * repetitionCount;

      if (totalQtyUsed > e.remQty) {
        allValid = false;
        break;
      }

      for (int k = 0; k < repetitionCount; k++) {
        List<Map<String, dynamic>> result = [];
        if (e.repeated.isNotEmpty) {
          result = e.consumeFromRepeated(qtyPerRepetition);
        }
        e.consume(qtyPerRepetition);

        rollbackData.add({
          "carpet": e,
          "qty": qtyPerRepetition,
          "consumed_repeated": result,
        });

        usedItems.add(
          CarpetUsed(
            carpetId: e.id,
            width: e.width,
            height: e.height,
            qtyUsed: qtyPerRepetition,
            qtyRem: e.remQty,
            clientOrder: e.clientOrder,
            repeated: result,
          ),
        );
      }
    }

    if (!allValid || usedItems.length < 2) {
      _rollbackConsumption(rollbackData);
      return null;
    }

    GroupCarpet newGroup = GroupCarpet(
      groupId: currentGroupId,
      items: usedItems,
    );

    if (newGroup.isValid(minWidth, maxWidth)) {
      if (pathLength > 0 && newGroup.maxLengthRef > pathLength) {
        _rollbackConsumption(rollbackData);
        return null;
      }
      return ProcessResult(newGroup, currentGroupId + 1);
    }

    _rollbackConsumption(rollbackData);
    return null;
  }

  void _rollbackConsumption(List<Map<String, dynamic>> rollbackData) {
    for (var item in rollbackData) {
      Carpet carpet = item["carpet"];
      int qty = item["qty"];
      List<Map<String, dynamic>> consumedRepeated = item["consumed_repeated"];

      carpet.remQty += qty;

      if (consumedRepeated.isNotEmpty) {
        carpet.restoreRepeated(consumedRepeated);
      }
    }
  }
}
