import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/models/carpet.dart';
import 'package:cut_optimizer_mobile/models/carpet_used.dart';
import 'package:cut_optimizer_mobile/models/group_carpet.dart';

void main() {
  group('Carpet Tests', () {
    test('Carpet initialization and area', () {
      final carpet = Carpet(
        id: 1,
        width: 100,
        height: 200,
        qty: 10,
        clientOrder: 123,
      );

      expect(carpet.remQty, 10);
      expect(carpet.area, 20000);
      expect(carpet.isAvailable, true);
    });

    test('Carpet consumption', () {
      final carpet = Carpet(
        id: 1,
        width: 100,
        height: 200,
        qty: 10,
        clientOrder: 123,
      );

      carpet.consume(5);
      expect(carpet.remQty, 5);
      
      carpet.consume(5);
      expect(carpet.remQty, 0);
      expect(carpet.isAvailable, false);

      expect(() => carpet.consume(1), throwsException);
    });

    test('Carpet repeated consumption', () {
      final carpet = Carpet(
        id: 1,
        width: 100,
        height: 200,
        qty: 0,
        clientOrder: 123,
        repeated: [
          {"id": 101, "qty_rem": 5, "qty_original": 5, "client_order": 1},
          {"id": 102, "qty_rem": 3, "qty_original": 3, "client_order": 1},
        ],
      );

      final consumed = carpet.consumeFromRepeated(6);
      
      expect(consumed.length, 2);
      expect(consumed[0]["id"], 101);
      expect(consumed[0]["qty"], 5);
      expect(consumed[1]["id"], 102);
      expect(consumed[1]["qty"], 1);
      
      expect(carpet.repeated.length, 1); // First one should be removed
      expect(carpet.repeated[0]["id"], 102);
      expect(carpet.repeated[0]["qty_rem"], 2);
    });
    
    test('Carpet restore repeated', () {
       final carpet = Carpet(
        id: 1,
        width: 100,
        height: 200,
        qty: 0,
        clientOrder: 123,
        repeated: [
          {"id": 102, "qty_rem": 2, "qty_original": 3, "client_order": 1},
        ],
      );
      
      final consumedList = [
          {"id": 101, "qty": 5, "qty_original": 5, "client_order": 1}, // Was fully consumed
          {"id": 102, "qty": 1, "qty_original": 3, "client_order": 1}, // Was partially consumed
      ];
      
      carpet.restoreRepeated(consumedList);
      
      expect(carpet.repeated.length, 2);
      
      // Check restored item 102
      final restored102 = carpet.repeated.firstWhere((e) => e["id"] == 102);
      expect(restored102["qty_rem"], 3);
      
      // Check restored item 101
      final restored101 = carpet.repeated.firstWhere((e) => e["id"] == 101);
      expect(restored101["qty_rem"], 5);
    });
  });

  group('CarpetUsed Tests', () {
    test('CarpetUsed properties', () {
      final carpetUsed = CarpetUsed(
        carpetId: 1,
        width: 100,
        height: 200,
        qtyUsed: 2,
        qtyRem: 8,
        clientOrder: 123,
      );

      expect(carpetUsed.lengthRef, 400);
      expect(carpetUsed.area, 40000);
      expect(carpetUsed.summary(), "id:1 | 100*200");
    });
  });

  group('GroupCarpet Tests', () {
    test('GroupCarpet calculations', () {
      final item1 = CarpetUsed(carpetId: 1, width: 100, height: 200, qtyUsed: 1, qtyRem: 0, clientOrder: 1);
      final item2 = CarpetUsed(carpetId: 2, width: 150, height: 200, qtyUsed: 1, qtyRem: 0, clientOrder: 1);
      
      final group = GroupCarpet(groupId: 1, items: [item1, item2]);

      expect(group.totalWidth, 250);
      expect(group.totalHeight, 400);
      expect(group.maxHeight, 200);
      expect(group.maxWidth, 150);
      expect(group.minWidth, 100);
      expect(group.totalQty, 2);
      expect(group.totalArea, 100*200 + 150*200);
      expect(group.isValid(200, 300), true);
      expect(group.isValid(260, 300), false);
    });
  });
}
