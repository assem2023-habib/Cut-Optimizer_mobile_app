import '../core/enums.dart';

class Config {
  int minWidth;
  int maxWidth;
  int toleranceLength;
  int? minTotalArea;
  int? maxTotalArea;
  int maxPartner;
  bool startWithLargest;
  bool allowSplitRows;
  String theme;
  String backgroundImage;
  GroupingMode selectedMode;
  SortType selectedSortType;

  Config({
    required this.minWidth,
    required this.maxWidth,
    required this.toleranceLength,
    this.minTotalArea,
    this.maxTotalArea,
    required this.maxPartner,
    required this.startWithLargest,
    required this.allowSplitRows,
    required this.theme,
    required this.backgroundImage,
    required this.selectedMode,
    required this.selectedSortType,
  });

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      minWidth: json['min_width'] as int,
      maxWidth: json['max_width'] as int,
      toleranceLength: json['tolerance_length'] as int,
      minTotalArea: json['min_total_area'] as int?,
      maxTotalArea: json['max_total_area'] as int?,
      maxPartner: json['max_partner'] as int,
      startWithLargest: json['start_with_largest'] as bool,
      allowSplitRows: json['allow_split_rows'] as bool,
      theme: json['theme'] as String,
      backgroundImage: json['background_image'] as String,
      selectedMode: _parseGroupingMode(json['selected_mode'] as String),
      selectedSortType: _parseSortType(json['selected_sort_type'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_width': minWidth,
      'max_width': maxWidth,
      'tolerance_length': toleranceLength,
      'min_total_area': minTotalArea,
      'max_total_area': maxTotalArea,
      'max_partner': maxPartner,
      'start_with_largest': startWithLargest,
      'allow_split_rows': allowSplitRows,
      'theme': theme,
      'background_image': backgroundImage,
      'selected_mode': _groupingModeToString(selectedMode),
      'selected_sort_type': _sortTypeToString(selectedSortType),
    };
  }

  static GroupingMode _parseGroupingMode(String value) {
    switch (value) {
      case 'all combinations':
        return GroupingMode.allCombinations;
      case 'no main repeat':
        return GroupingMode.noMainRepeat;
      default:
        return GroupingMode.allCombinations;
    }
  }

  static String _groupingModeToString(GroupingMode mode) {
    switch (mode) {
      case GroupingMode.allCombinations:
        return 'all combinations';
      case GroupingMode.noMainRepeat:
        return 'no main repeat';
    }
  }

  static SortType _parseSortType(String value) {
    switch (value) {
      case 'sort carpet by width':
        return SortType.sortByWidth;
      case 'sort carpet by quantity':
        return SortType.sortByQuantity;
      case 'sort carpet by height':
        return SortType.sortByHeight;
      default:
        return SortType.sortByWidth;
    }
  }

  static String _sortTypeToString(SortType type) {
    switch (type) {
      case SortType.sortByWidth:
        return 'sort carpet by width';
      case SortType.sortByQuantity:
        return 'sort carpet by quantity';
      case SortType.sortByHeight:
        return 'sort carpet by height';
    }
  }

  static Config defaultConfig() {
    return Config(
      minWidth: 370,
      maxWidth: 400,
      toleranceLength: 100,
      minTotalArea: null,
      maxTotalArea: null,
      maxPartner: 7,
      startWithLargest: true,
      allowSplitRows: true,
      theme: "dark",
      backgroundImage: "config\\backgrounds\\img1.jpg",
      selectedMode: GroupingMode.allCombinations,
      selectedSortType: SortType.sortByWidth,
    );
  }
}
