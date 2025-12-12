import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import '../../core/enums.dart';
import '../../core/combination_utils.dart';
import 'algorithm_models.dart';
import 'group_processor.dart';

class PartnerProcessor {
  final GroupProcessor _groupProcessor = GroupProcessor();

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
    required int pathLength,
  }) {
    List<GroupCarpet> groups = [];
    int currentGroupId = groupId;

    if (!main.isAvailable) {
      return GenerateResult(groups, currentGroupId);
    }

    List<List<Carpet>> partnerSets = [];

    if (selectedMode == GroupingMode.noMainRepeat) {
      partnerSets.addAll(
        CombinationUtils.generateValidPartnerCombinations(
          main: main,
          candidates: carpets,
          n: partnerLevel,
          minWidth: minWidth,
          maxWidth: maxWidth,
          allowRepetition: false,
          startIndex: startIndex,
          excludeMain: true,
        ),
      );
      partnerSets.addAll(
        CombinationUtils.generateValidPartnerCombinations(
          main: main,
          candidates: carpets,
          n: partnerLevel,
          minWidth: minWidth,
          maxWidth: maxWidth,
          allowRepetition: true,
          startIndex: startIndex,
          excludeMain: true,
        ),
      );
    } else {
      partnerSets.addAll(
        CombinationUtils.generateValidPartnerCombinations(
          main: main,
          candidates: carpets,
          n: partnerLevel,
          minWidth: minWidth,
          maxWidth: maxWidth,
          allowRepetition: false,
          startIndex: startIndex,
        ),
      );
      partnerSets.addAll(
        CombinationUtils.generateValidPartnerCombinations(
          main: main,
          candidates: carpets,
          n: partnerLevel,
          minWidth: minWidth,
          maxWidth: maxWidth,
          allowRepetition: true,
          startIndex: startIndex,
        ),
      );
    }

    for (var partners in partnerSets) {
      if (!main.isAvailable) {
        break;
      }
      var result = _groupProcessor.processPartnerGroup(
        main,
        partners,
        tolerance,
        currentGroupId,
        minWidth,
        maxWidth,
        pathLength,
      );
      if (result != null) {
        groups.add(result.group);
        currentGroupId = result.nextGroupId;
      }
    }

    return GenerateResult(groups, currentGroupId);
  }
}
