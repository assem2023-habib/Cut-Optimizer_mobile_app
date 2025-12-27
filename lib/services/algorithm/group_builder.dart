import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import '../../core/enums.dart';
import 'partner_processor.dart';
import 'single_group_creator.dart';

class GroupBuilder {
  final PartnerProcessor _partnerProcessor = PartnerProcessor();
  final SingleGroupCreator _singleGroupCreator = SingleGroupCreator();

  List<GroupCarpet> buildGroups({
    required List<Carpet> carpets,
    required int minWidth,
    required int maxWidth,
    int maxPartner = 7,
    int tolerance = 0,
    GroupingMode selectedMode = GroupingMode.allCombinations,
    SortType selectedSortType = SortType.sortByWidth,
    required int pathLength,
  }) {
    _sortCarpets(carpets, selectedSortType);

    List<GroupCarpet> group = [];
    int groupId = 1;

    for (var main in carpets) {
      if (!main.isAvailable) {
        continue;
      }

      int startIndex = _findStartIndex(
        carpets,
        main,
        maxWidth,
        selectedSortType,
      );

      int currentMaxPartner = _calculateMaxPartner(minWidth, main.width);

      for (int partnerLevel = 1; partnerLevel <= currentMaxPartner; partnerLevel++) {
        if (!main.isAvailable) {
          break;
        }
        int remQty = main.remQty;
        var result = _partnerProcessor.generateAndProcessPartners(
          main: main,
          carpets: carpets,
          partnerLevel: partnerLevel,
          minWidth: minWidth,
          maxWidth: maxWidth,
          tolerance: tolerance,
          groupId: groupId,
          selectedMode: selectedMode,
          startIndex: startIndex,
          pathLength: pathLength,
        );

        List<GroupCarpet> newGroups = result.groups;
        groupId = result.nextGroupId;

        if (selectedSortType == SortType.sortByQuantity) {
          if (newGroups.isEmpty) {
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
          var result = _partnerProcessor.generateAndProcessPartners(
            main: main,
            carpets: carpets,
            partnerLevel: partnerLevel,
            minWidth: minWidth,
            maxWidth: maxWidth,
            tolerance: tolerance,
            groupId: groupId,
            selectedMode: GroupingMode.allCombinations,
            startIndex: startIndex,
            pathLength: pathLength,
          );
          group.addAll(result.groups);
          groupId = result.nextGroupId;
        }
      }

      var singleGroup = _singleGroupCreator.tryCreateSingleGroup(
        main,
        minWidth,
        maxWidth,
        groupId,
      );
      if (singleGroup != null) {
        group.add(singleGroup);
        groupId++;
      }
    }

    _sortGroupsForOutput(group);

    return group;
  }

  void _sortCarpets(List<Carpet> carpets, SortType selectedSortType) {
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
  }

  int _findStartIndex(
    List<Carpet> carpets,
    Carpet main,
    int maxWidth,
    SortType selectedSortType,
  ) {
    if (selectedSortType == SortType.sortByQuantity) {
      return 0;
    }

    int remainingWidth = maxWidth - main.width;
    int foundIndex = -1;
    for (int j = 0; j < carpets.length; j++) {
      if (carpets[j].width <= remainingWidth) {
        foundIndex = j;
        break;
      }
    }

    if (foundIndex == -1) {
      return 0;
    }
    return foundIndex;
  }

  int _calculateMaxPartner(int minWidth, int mainWidth) {
    int currentMaxPartner = 7;
    if (minWidth >= 370 && minWidth <= 400 && mainWidth <= 70) {
      currentMaxPartner = 10;
    }
    if (minWidth >= 470 && mainWidth <= 60) {
      currentMaxPartner = 12;
    }
    return currentMaxPartner;
  }

  void _sortGroupsForOutput(List<GroupCarpet> group) {
    for (var g in group) {
      g.sortItemsByWidth(reverse: true);
    }

    group.sort((a, b) {
      int widthA = a.items.isNotEmpty ? a.items[0].width : 0;
      int widthB = b.items.isNotEmpty ? b.items[0].width : 0;
      return widthB.compareTo(widthA);
    });
  }
}
