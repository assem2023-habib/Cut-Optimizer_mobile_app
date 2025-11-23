import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/models/carpet.dart';
import 'package:cut_optimizer_mobile/services/algorithm_service.dart';
import 'package:cut_optimizer_mobile/core/enums.dart';

void main() {
  group('Algorithm Service Tests', () {
    late AlgorithmService service;

    setUp(() {
      service = AlgorithmService();
    });

    test('Build Groups - Simple Exact Match', () {
      // Carpet 1: 100 width
      // Carpet 2: 100 width
      // Min width 200, Max 200
      final c1 = Carpet(id: 1, width: 100, height: 200, qty: 1, clientOrder: 1);
      final c2 = Carpet(id: 2, width: 100, height: 200, qty: 1, clientOrder: 1);
      
      final groups = service.buildGroups(
        carpets: [c1, c2],
        minWidth: 200,
        maxWidth: 200,
        selectedMode: GroupingMode.allCombinations,
      );

      expect(groups.length, 1);
      expect(groups[0].items.length, 2);
      expect(groups[0].totalWidth, 200);
    });

    test('Build Groups - Single Group', () {
        final c1 = Carpet(id: 1, width: 200, height: 200, qty: 1, clientOrder: 1);
        
        final groups = service.buildGroups(
            carpets: [c1],
            minWidth: 200,
            maxWidth: 200,
        );
        
        expect(groups.length, 1);
        expect(groups[0].items.length, 1);
        expect(groups[0].totalWidth, 200);
    });
    
    test('Build Groups - Complex', () {
        // c1: 100, qty 10
        // c2: 50, qty 10
        // target: 150
        final c1 = Carpet(id: 1, width: 100, height: 200, qty: 10, clientOrder: 1);
        final c2 = Carpet(id: 2, width: 50, height: 200, qty: 10, clientOrder: 1);
        
        final groups = service.buildGroups(
            carpets: [c1, c2],
            minWidth: 150,
            maxWidth: 150,
        );
        
        // Should pair 100+50 ten times.
        // Or maybe group them into one group with multiple items if logic allows?
        // The logic creates a GroupCarpet for each valid combination found until exhaustion.
        // Wait, `processPartnerGroup` consumes as much as possible for a given combination (using equalProductsSolution).
        // So it should create one GroupCarpet with items having qty_used=10?
        // Let's check `processPartnerGroup`.
        // It calculates `kMax` (max multiplier).
        // If x=[1, 1] for [100, 50], and we have 10 of each.
        // kMax will be 10.
        // So it will consume 10 of each.
        // And create ONE GroupCarpet with items having qtyUsed=10.
        
        expect(groups.length, 1);
        expect(groups[0].items.length, 2);
        expect(groups[0].items[0].qtyUsed, 10);
        expect(groups[0].items[1].qtyUsed, 10);
    });

    test('Generate Suggestions', () {
      final c1 = Carpet(id: 1, width: 100, height: 200, qty: 10, clientOrder: 1);
      final c2 = Carpet(id: 2, width: 50, height: 200, qty: 10, clientOrder: 1);
      
      // Target 150.
      // Suggestions loop reduces min/max by step (10).
      // 1. 150-150. Matches.
      // 2. 140-140. No match (min width 50).
      // ...
      
      final suggestions = service.generateSuggestions(
        remaining: [c1, c2],
        minWidth: 150,
        maxWidth: 150,
        tolerance: 0,
        step: 10,
      );
      
      // Should find at least one suggestion (the exact match)
      expect(suggestions.isNotEmpty, true);
      expect(suggestions[0].length, 1);
      expect(suggestions[0][0].totalWidth, 150);
    });
  });
}
