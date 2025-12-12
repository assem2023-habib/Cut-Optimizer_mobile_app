import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import '../../core/enums.dart';
import 'group_builder.dart';
import 'suggestions_generator.dart';

class AlgorithmServiceRefactored {
  final GroupBuilder _groupBuilder = GroupBuilder();
  final SuggestionsGenerator _suggestionsGenerator = SuggestionsGenerator();

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
    return _groupBuilder.buildGroups(
      carpets: carpets,
      minWidth: minWidth,
      maxWidth: maxWidth,
      maxPartner: maxPartner,
      tolerance: tolerance,
      selectedMode: selectedMode,
      selectedSortType: selectedSortType,
      pathLength: pathLength,
    );
  }

  List<List<GroupCarpet>> generateSuggestions({
    required List<Carpet> remaining,
    required int minWidth,
    required int maxWidth,
    required int tolerance,
    int pathLength = 0,
    int step = 10,
  }) {
    return _suggestionsGenerator.generateSuggestions(
      remaining: remaining,
      minWidth: minWidth,
      maxWidth: maxWidth,
      tolerance: tolerance,
      pathLength: pathLength,
      step: step,
    );
  }
}
