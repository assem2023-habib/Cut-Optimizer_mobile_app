import 'dart:math';
import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import 'group_builder.dart';

class SuggestionsGenerator {
  final GroupBuilder _groupBuilder = GroupBuilder();

  List<List<GroupCarpet>> generateSuggestions({
    required List<Carpet> remaining,
    required int minWidth,
    required int maxWidth,
    required int tolerance,
    int pathLength = 0,
    int step = 10,
  }) {
    List<List<GroupCarpet>> suggestions = [];

    var availableCarpets = remaining.where((c) => c.remQty > 0).toList();
    if (availableCarpets.isEmpty) return suggestions;

    int minRemainingWidth = availableCarpets.map((c) => c.width).reduce(min);

    List<Carpet> workCopy = remaining.map((c) => c.clone()).toList();

    int currentMin = minWidth;
    int currentMax = maxWidth;

    while (currentMax > minRemainingWidth) {
      List<Carpet> carpetsForRun = workCopy.map((c) => c.clone()).toList();

      List<GroupCarpet> groups = _groupBuilder.buildGroups(
        carpets: carpetsForRun,
        minWidth: currentMin,
        maxWidth: currentMax,
        maxPartner: 9,
        tolerance: tolerance,
        pathLength: pathLength,
      );

      if (groups.isNotEmpty) {
        String currentSummary = groups.map((g) => g.summary()).join("|");
        bool exists = suggestions.any(
          (s) => s.map((g) => g.summary()).join("|") == currentSummary,
        );

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
