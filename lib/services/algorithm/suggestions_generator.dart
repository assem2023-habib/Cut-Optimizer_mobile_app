import 'dart:math';
import '../../models/carpet.dart';
import '../../models/group_carpet.dart';
import '../../models/carpet_used.dart';
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
      
      // Create suggestion even if complementary width is small, but still positive
      if (complementaryWidth > 0) {
        var complementaryCarpet = Carpet(
          id: originalCarpet.id + 10000, // Different ID to avoid conflicts
          width: complementaryWidth,
          height: originalCarpet.height,
          qty: originalCarpet.qty,
          clientOrder: originalCarpet.clientOrder,
        );
        
        // Create a group with both items
        var originalUsed = CarpetUsed(
          carpetId: originalCarpet.id,
          width: originalCarpet.width,
          height: originalCarpet.height,
          qtyUsed: originalCarpet.qty,
          qtyRem: 0,
          clientOrder: originalCarpet.clientOrder,
        );
        
        var complementaryUsed = CarpetUsed(
          carpetId: complementaryCarpet.id,
          width: complementaryCarpet.width,
          height: complementaryCarpet.height,
          qtyUsed: complementaryCarpet.qty,
          qtyRem: 0,
          clientOrder: complementaryCarpet.clientOrder,
        );
        
        var group = GroupCarpet(
          groupId: DateTime.now().millisecondsSinceEpoch % 10000,
          items: [originalUsed, complementaryUsed],
        );
        
        suggestionGroups.add(group);
        suggestions.add(suggestionGroups);
      }
    }

    return suggestions;
  }
}
