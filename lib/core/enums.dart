enum GroupingMode {
  noMainRepeat("no_main_repeat"),
  allCombinations("all_combinations");

  final String value;
  const GroupingMode(this.value);

  static GroupingMode? fromString(String value) {
    try {
      return GroupingMode.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum SortType {
  sortByWidth("sort_by_width"),
  sortByQuantity("sort_by_quantity"),
  sortByHeight("sort_by_height");

  final String value;
  const SortType(this.value);

  static SortType? fromString(String value) {
    try {
      return SortType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
