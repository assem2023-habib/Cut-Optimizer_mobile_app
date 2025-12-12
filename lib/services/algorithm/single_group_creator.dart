import '../../models/carpet.dart';
import '../../models/carpet_used.dart';
import '../../models/group_carpet.dart';

class SingleGroupCreator {
  GroupCarpet? tryCreateSingleGroup(
    Carpet carpet,
    int minWidth,
    int maxWidth,
    int groupId,
  ) {
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

    int qtyToConsume = carpet.remQty;

    CarpetUsed singleItem = CarpetUsed(
      carpetId: carpet.id,
      width: carpet.width,
      height: carpet.height,
      qtyUsed: qtyToConsume,
      qtyRem: 0,
      clientOrder: carpet.clientOrder,
      repeated: result,
    );

    GroupCarpet singleGroup = GroupCarpet(
      groupId: groupId,
      items: [singleItem],
    );

    if (!singleGroup.isValid(minWidth, maxWidth)) {
      if (result.isNotEmpty) {
        carpet.restoreRepeated(result);
      }
      return null;
    }

    carpet.consume(qtyToConsume);
    return singleGroup;
  }
}
