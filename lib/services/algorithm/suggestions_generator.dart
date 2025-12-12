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

    // Generate simple suggestions: for each remaining item, create a complementary item
    for (var carpet in availableCarpets) {
      List<GroupCarpet> suggestionGroups = [];
      
      // Create the original item
      var originalCarpet = carpet.clone();
      
      // Create complementary item with same length and quantity, but width = maxWidth - originalWidth
      int complementaryWidth = maxWidth - originalCarpet.width;
      if (complementaryWidth >= minWidth) {
        var complementaryCarpet = Carpet(
          id: originalCarpet.id + 10000, // Different ID to avoid conflicts
          width: complementaryWidth,
          height: originalCarpet.height,
          qty: originalCarpet.qty,
          clientOrder: originalCarpet.clientOrder,
        );
        
        // Create a group with both items
        var group = GroupCarpet(
          carpets: [originalCarpet, complementaryCarpet],
          maxWidth: maxWidth,
          tolerance: tolerance,
          pathLength: pathLength,
        );
        
        suggestionGroups.add(group);
        suggestions.add(suggestionGroups);
      }
    }

    return suggestions;
  }
}
