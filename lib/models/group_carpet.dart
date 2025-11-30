import 'carpet_used.dart';
import 'dart:math' as math;

class GroupCarpet {
  final int groupId;
  final List<CarpetUsed> items;

  final int repetitions;

  GroupCarpet({
    required this.groupId,
    List<CarpetUsed>? items,
    this.repetitions = 1,
  }) : items = items ?? [];

  int get totalWidth => items.fold(0, (sum, item) => sum + item.width);

  int get totalHeight => items.fold(0, (sum, item) => sum + item.height);

  int get totalLengthRef => items.fold(0, (sum, item) => sum + item.lengthRef);

  int get maxHeight =>
      items.isEmpty ? 0 : items.map((e) => e.height).reduce(math.max);

  int get maxWidth =>
      items.isEmpty ? 0 : items.map((e) => e.width).reduce(math.max);

  int get minWidth =>
      items.isEmpty ? 0 : items.map((e) => e.width).reduce(math.min);

  int get maxLengthRef =>
      items.isEmpty ? 0 : items.map((e) => e.lengthRef).reduce(math.max);

  int get minLengthRef =>
      items.isEmpty ? 0 : items.map((e) => e.lengthRef).reduce(math.min);

  int get totalQty => items.fold(0, (sum, item) => sum + item.qtyUsed);

  int get totalRemQty => items.fold(0, (sum, item) => sum + item.qtyRem);

  int get totalArea => items.fold(0, (sum, item) => sum + item.area);

  bool isValid(int minWidth, int maxWidth) {
    int tw = totalWidth;
    return minWidth <= tw && tw <= maxWidth;
  }

  String summary() {
    String itemsDesc = items.map((i) => i.summary()).join(", ");
    return "Group $groupId: "
        "width=${totalWidth.toStringAsFixed(2)}, height=${totalHeight.toStringAsFixed(2)}, "
        "qty=$totalQty, area=${totalArea.toStringAsFixed(2)}, "
        "items=[$itemsDesc]";
  }

  int get refHeight {
    if (items.isEmpty) {
      return 0;
    }
    return items[0].lengthRef;
  }

  void sortItemsByWidth({bool reverse = false}) {
    items.sort(
      (a, b) =>
          reverse ? b.width.compareTo(a.width) : a.width.compareTo(b.width),
    );
  }
}
