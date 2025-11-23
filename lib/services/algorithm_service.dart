import 'dart:math';
import '../models/carpet.dart';
import '../models/carpet_used.dart';
import '../models/group_carpet.dart';
import '../core/enums.dart';
import '../core/math_utils.dart';
import '../core/combination_utils.dart';

class AlgorithmService {
  List<GroupCarpet> buildGroups({
    required List<Carpet> carpets,
    required int minWidth,
    required int maxWidth,
    int maxPartner = 7,
    int tolerance = 0,
    GroupingMode selectedMode = GroupingMode.allCombinations,
    SortType selectedSortType = SortType.sortByWidth,
  }) {
    // Sort carpets based on selected type
    if (selectedSortType == SortType.sortByWidth) {
      carpets.sort((a, b) {
        int cmp = b.width.compareTo(a.width);
        if (cmp != 0) return cmp;
        cmp = b.height.compareTo(a.height);
        if (cmp != 0) return cmp;
        return b.qty.compareTo(a.qty);
      });
    } else if (selectedSortType == SortType.sortByQuantity) {
      carpets.sort((a, b) {
        int cmp = b.remQty.compareTo(a.remQty);
        if (cmp != 0) return cmp;
        cmp = b.height.compareTo(a.height);
        if (cmp != 0) return cmp;
        return b.width.compareTo(a.width);
      });
    } else if (selectedSortType == SortType.sortByHeight) {
      carpets.sort((a, b) {
        int cmp = b.height.compareTo(a.height);
        if (cmp != 0) return cmp;
        cmp = b.width.compareTo(a.width);
        if (cmp != 0) return cmp;
        return b.qty.compareTo(a.qty);
      });
    }

    List<GroupCarpet> group = [];
    int groupId = 1;

    // We iterate through a copy or handle the loop carefully since we modify state
    // The python loop iterates over `carpets` which is a list.
    // In Dart, we can iterate over the list.
    
    // Note: The python logic iterates over `carpets` but inside the loop it might modify `rem_qty` of items in `carpets`.
    // It does NOT remove items from `carpets` list itself during iteration, so standard for-in is fine.
    
    for (var main in carpets) {
      if (!main.isAvailable) {
        continue;
      }

      int startIndex = 0;

      if (selectedSortType != SortType.sortByQuantity) {
        int remainingWidth = maxWidth - main.width;
        
        // Find first index where width <= remainingWidth
        int foundIndex = -1;
        for(int j=0; j<carpets.length; j++) {
            if (carpets[j].width <= remainingWidth) {
                foundIndex = j;
                break;
            }
        }
        
        if (foundIndex == -1) {
          var singleGroup = tryCreateSingleGroup(
              main, minWidth, maxWidth, groupId);
          if (singleGroup != null) {
            group.add(singleGroup);
            groupId++;
          }
          continue;
        }
        startIndex = foundIndex;
      }

      int currentMaxPartner = maxPartner;
      if (minWidth >= 370 && minWidth <= 400 && main.width <= 70) {
        currentMaxPartner = 10;
      }
      if (minWidth >= 470 && main.width <= 60) {
        currentMaxPartner = 12;
      }

      for (int partnerLevel = 1; partnerLevel <= currentMaxPartner; partnerLevel++) {
        if (!main.isAvailable) {
          break;
        }
        int remQty = main.remQty;
        var result = generateAndProcessPartners(
          main: main,
          carpets: carpets,
          partnerLevel: partnerLevel,
          minWidth: minWidth,
          maxWidth: maxWidth,
          tolerance: tolerance,
          groupId: groupId,
          selectedMode: selectedMode,
          startIndex: startIndex,
        );
        
        List<GroupCarpet> newGroups = result.groups;
        groupId = result.nextGroupId;

        if (selectedSortType == SortType.sortByQuantity) {
          if (newGroups.isEmpty) {
            // Restore remQty if no groups found (as per python logic?)
            // Wait, python code says:
            // if not new_groups:
            //    main.rem_qty= rem_qty
            //    continue
            // This implies that `generateAndProcessPartners` might have consumed something even if it returned empty groups?
            // Or maybe it's just a safety reset?
            // `generateAndProcessPartners` only consumes if it successfully creates a group.
            // However, let's follow the python logic exactly.
             main.remQty = remQty;
             continue;
          }
        }
        group.addAll(newGroups);
      }

      if (selectedMode == GroupingMode.noMainRepeat) {
        for (int partnerLevel = 1; partnerLevel <= currentMaxPartner; partnerLevel++) {
          if (!main.isAvailable) {
            break;
          }
           var result = generateAndProcessPartners(
            main: main,
            carpets: carpets,
            partnerLevel: partnerLevel,
            minWidth: minWidth,
            maxWidth: maxWidth,
            tolerance: tolerance,
            groupId: groupId,
            selectedMode: GroupingMode.allCombinations, // Force all combinations here as per python logic
            startIndex: startIndex,
          );
          group.addAll(result.groups);
          groupId = result.nextGroupId;
        }
      }

      var singleGroup = tryCreateSingleGroup(
          main, minWidth, maxWidth, groupId);
      if (singleGroup != null) {
        group.add(singleGroup);
        groupId++;
      }
    }

    for (var g in group) {
      g.sortItemsByWidth(reverse: true);
    }

    group.sort((a, b) {
        int widthA = a.items.isNotEmpty ? a.items[0].width : 0;
        int widthB = b.items.isNotEmpty ? b.items[0].width : 0;
        return widthB.compareTo(widthA);
    });

    return group;
  }

  GenerateResult generateAndProcessPartners({
    required Carpet main,
    required List<Carpet> carpets,
    required int partnerLevel,
    required int minWidth,
    required int maxWidth,
    required int tolerance,
    required int groupId,
    required GroupingMode selectedMode,
    required int startIndex,
  }) {
    List<GroupCarpet> groups = [];
    int currentGroupId = groupId;

    if (!main.isAvailable) {
      return GenerateResult(groups, currentGroupId);
    }

    List<List<Carpet>> partnerSets = [];

    if (selectedMode == GroupingMode.noMainRepeat) {
      partnerSets.addAll(CombinationUtils.generateValidPartnerCombinations(
        main: main,
        candidates: carpets,
        n: partnerLevel,
        minWidth: minWidth,
        maxWidth: maxWidth,
        allowRepetition: false,
        startIndex: startIndex,
        excludeMain: true,
      ));
      partnerSets.addAll(CombinationUtils.generateValidPartnerCombinations(
        main: main,
        candidates: carpets,
        n: partnerLevel,
        minWidth: minWidth,
        maxWidth: maxWidth,
        allowRepetition: true,
        startIndex: startIndex,
        excludeMain: true,
      ));
    } else {
      partnerSets.addAll(CombinationUtils.generateValidPartnerCombinations(
        main: main,
        candidates: carpets,
        n: partnerLevel,
        minWidth: minWidth,
        maxWidth: maxWidth,
        allowRepetition: false,
        startIndex: startIndex,
      ));
      partnerSets.addAll(CombinationUtils.generateValidPartnerCombinations(
        main: main,
        candidates: carpets,
        n: partnerLevel,
        minWidth: minWidth,
        maxWidth: maxWidth,
        allowRepetition: true,
        startIndex: startIndex,
      ));
    }

    for (var partners in partnerSets) {
      if (!main.isAvailable) {
        break;
      }
      var result = processPartnerGroup(
        main,
        partners,
        tolerance,
        currentGroupId,
        minWidth,
        maxWidth,
      );
      if (result != null) {
        groups.add(result.group);
        currentGroupId = result.nextGroupId;
      }
    }

    return GenerateResult(groups, currentGroupId);
  }

  ProcessResult? processPartnerGroup(
    Carpet main,
    List<Carpet> partners,
    int tolerance,
    int currentGroupId,
    int minWidth,
    int maxWidth,
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
      eqResult = equalProductsSolution(a, xMax);
    } else {
      eqResult = equalProductsSolutionWithTolerance(a, xMax, tolerance);
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
        // Check if repeated is not empty
        if (e.repeated.isNotEmpty) {
            result = e.consumeFromRepeated(qtyPerRepetition);
        }
        e.consume(qtyPerRepetition);

        rollbackData.add({
          "carpet": e,
          "qty": qtyPerRepetition,
          "consumed_repeated": result
        });

        usedItems.add(CarpetUsed(
          carpetId: e.id,
          width: e.width,
          height: e.height,
          qtyUsed: qtyPerRepetition,
          qtyRem: e.remQty,
          clientOrder: e.clientOrder,
          repeated: result,
        ));
      }
    }

    if (!allValid || usedItems.length < 2) {
      rollbackConsumption(rollbackData);
      return null;
    }

    GroupCarpet newGroup = GroupCarpet(groupId: currentGroupId, items: usedItems);
    if (newGroup.isValid(minWidth, maxWidth)) {
      return ProcessResult(newGroup, currentGroupId + 1);
    }

    rollbackConsumption(rollbackData);
    return null;
  }

  GroupCarpet? tryCreateSingleGroup(
      Carpet carpet, int minWidth, int maxWidth, int groupId) {
    if (!(carpet.width >= minWidth &&
        carpet.width <= maxWidth &&
        carpet.isAvailable &&
        carpet.remQty > 0)) {
      return null;
    }

    List<Map<String, dynamic>> result = [];
    if (carpet.repeated.isNotEmpty) {
      result = carpet.consumeFromRepeated(carpet.remQty);
    }
    
    // Note: In python code, it consumes rem_qty.
    int qtyToConsume = carpet.remQty;

    CarpetUsed singleItem = CarpetUsed(
      carpetId: carpet.id,
      width: carpet.width,
      height: carpet.height,
      qtyUsed: qtyToConsume, // In python it was carpet.rem_qty before consume
      qtyRem: 0,
      clientOrder: carpet.clientOrder,
      repeated: result, // Python code didn't pass repeated to CarpetUsed constructor in try_create_single_group explicitly but it seems it should if it consumed from repeated? 
      // Wait, python code:
      // result= []
      // if hasattr(carpet, "repeated") and carpet.repeated:
      //     result= carpet.consume_from_repeated(carpet.rem_qty)
      // single_item = CarpetUsed(..., repeated= result)
      // Yes it does pass it.
    );

    GroupCarpet singleGroup = GroupCarpet(groupId: groupId, items: [singleItem]);

    if (!singleGroup.isValid(minWidth, maxWidth)) {
        // If not valid, we should probably restore? 
        // But we haven't consumed yet in python code until AFTER validity check.
        // Python:
        // if not single_group.is_valid(...): return None
        // qty_to_consume = carpet.rem_qty
        // carpet.consume(qty_to_consume)
        // return single_group
        
        // Wait, if I consumed from repeated BEFORE validity check, I need to restore if invalid.
        // Python code consumes from repeated BEFORE validity check.
        // But consumes from main carpet AFTER validity check.
        // This looks like a potential bug in python code if it returns None, it doesn't restore repeated?
        // Let's look at python code again.
        /*
        result= []
        if hasattr(carpet, "repeated") and carpet.repeated:
            result= carpet.consume_from_repeated(carpet.rem_qty)
        single_item = CarpetUsed(..., repeated= result)
        single_group = GroupCarpet(..., items=[single_item])
        if not single_group.is_valid(min_width, max_width):
            return None
        */
        // YES! It seems it returns None without restoring repeated. 
        // I should fix this in Dart or follow it? I should probably fix it to be safe.
        // I will restore if invalid.
        if (result.isNotEmpty) {
            carpet.restoreRepeated(result);
        }
        return null;
    }

    carpet.consume(qtyToConsume);
    return singleGroup;
  }

  void rollbackConsumption(List<Map<String, dynamic>> rollbackData) {
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

class GenerateResult {
  final List<GroupCarpet> groups;
  final int nextGroupId;

  GenerateResult(this.groups, this.nextGroupId);
}

class ProcessResult {
  final GroupCarpet group;
  final int nextGroupId;

  ProcessResult(this.group, this.nextGroupId);
}

extension AlgorithmServiceExtensions on AlgorithmService {
  List<List<GroupCarpet>> generateSuggestions({
    required List<Carpet> remaining,
    required int minWidth,
    required int maxWidth,
    required int tolerance,
    int step = 10,
  }) {
    List<List<GroupCarpet>> suggestions = [];

    var availableCarpets = remaining.where((c) => c.remQty > 0).toList();
    if (availableCarpets.isEmpty) return suggestions;

    int minRemainingWidth = availableCarpets.map((c) => c.width).reduce(min);
    
    // Create a work copy of carpets to preserve original state across iterations if needed?
    // Actually, in the loop we create `carpetsForRun` which are deep copies of `workCopy`.
    // `workCopy` itself should be a deep copy of `remaining` to avoid modifying `remaining`.
    List<Carpet> workCopy = remaining.map((c) => c.clone()).toList();

    int currentMin = minWidth;
    int currentMax = maxWidth;

    while (currentMax > minRemainingWidth) {
      List<Carpet> carpetsForRun = workCopy.map((c) => c.clone()).toList();

      List<GroupCarpet> groups = buildGroups(
        carpets: carpetsForRun,
        minWidth: currentMin,
        maxWidth: currentMax,
        maxPartner: 9,
        tolerance: tolerance,
      );

      if (groups.isNotEmpty) {
         // Check if this set of groups is already in suggestions
         // We need a way to check equality of List<GroupCarpet>
         // For now, we can check if string summaries match or implement deep equality.
         // Using summary string for simplicity as it captures structure.
         String currentSummary = groups.map((g) => g.summary()).join("|");
         bool exists = suggestions.any((s) => s.map((g) => g.summary()).join("|") == currentSummary);
         
         if (!exists) {
           suggestions.add(groups);
         }
      }

      currentMin -= step;
      currentMax -= step;

      if (currentMin < 0) {
        currentMin = 0;
      }
    }
    return suggestions;
  }
}
