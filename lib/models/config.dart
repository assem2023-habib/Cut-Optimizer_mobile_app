import '../core/enums.dart';

enum BackgroundType { gradient, image }

enum MeasurementUnit { m2, m, cm }

enum PairOddMode { disabled, pair, odd }

class MachineSize {
  final String name;
  final int minWidth;
  final int maxWidth;
  final int tolerance;
  final int pathLength;
  final PairOddMode pairOddMode;

  MachineSize({
    required this.name,
    required this.minWidth,
    required this.maxWidth,
    this.tolerance = 0,
    this.pathLength = 0,
    this.pairOddMode = PairOddMode.disabled,
  });

  factory MachineSize.fromJson(Map<String, dynamic> json) {
    return MachineSize(
      name: json['name'] as String,
      minWidth: json['min_width'] as int,
      maxWidth: json['max_width'] as int,
      tolerance: json['tolerance'] as int? ?? 0,
      pathLength: json['path_length'] as int? ?? 0,
      pairOddMode: Config.parsePairOddMode(
        json['pair_odd_mode'] as String? ?? 'disabled',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'min_width': minWidth,
      'max_width': maxWidth,
      'tolerance': tolerance,
      'path_length': pathLength,
      'pair_odd_mode': Config.pairOddModeToString(pairOddMode),
    };
  }
}

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
  BackgroundType backgroundType;
  List<MachineSize> machineSizes;
  GroupingMode selectedMode;
  SortType selectedSortType;
  MeasurementUnit measurementUnit;

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
    required this.backgroundType,
    required this.machineSizes,
    required this.selectedMode,
    required this.selectedSortType,
    required this.measurementUnit,
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
      backgroundType: _parseBackgroundType(
        json['background_type'] as String? ?? 'gradient',
      ),
      machineSizes: (json['machine_sizes'] as List<dynamic>? ?? [])
          .map((e) => MachineSize.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedMode: _parseGroupingMode(json['selected_mode'] as String),
      selectedSortType: _parseSortType(json['selected_sort_type'] as String),
      measurementUnit: _parseMeasurementUnit(
        json['measurement_unit'] as String? ?? 'm2',
      ),
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
      'background_type': _backgroundTypeToString(backgroundType),
      'machine_sizes': machineSizes.map((e) => e.toJson()).toList(),
      'selected_mode': _groupingModeToString(selectedMode),
      'selected_sort_type': _sortTypeToString(selectedSortType),
      'measurement_unit': _measurementUnitToString(measurementUnit),
    };
  }

  static BackgroundType _parseBackgroundType(String value) {
    switch (value) {
      case 'gradient':
        return BackgroundType.gradient;
      case 'image':
        return BackgroundType.image;
      default:
        return BackgroundType.gradient;
    }
  }

  static String _backgroundTypeToString(BackgroundType type) {
    switch (type) {
      case BackgroundType.gradient:
        return 'gradient';
      case BackgroundType.image:
        return 'image';
    }
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

  static MeasurementUnit _parseMeasurementUnit(String value) {
    switch (value) {
      case 'm2':
        return MeasurementUnit.m2;
      case 'm':
        return MeasurementUnit.m;
      case 'cm':
        return MeasurementUnit.cm;
      default:
        return MeasurementUnit.m2;
    }
  }

  static String _measurementUnitToString(MeasurementUnit unit) {
    switch (unit) {
      case MeasurementUnit.m2:
        return 'm2';
      case MeasurementUnit.m:
        return 'm';
      case MeasurementUnit.cm:
        return 'cm';
    }
  }

  static PairOddMode parsePairOddMode(String value) {
    switch (value) {
      case 'pair':
        return PairOddMode.pair;
      case 'odd':
        return PairOddMode.odd;
      default:
        return PairOddMode.disabled;
    }
  }

  static String pairOddModeToString(PairOddMode mode) {
    switch (mode) {
      case PairOddMode.disabled:
        return 'disabled';
      case PairOddMode.pair:
        return 'pair';
      case PairOddMode.odd:
        return 'odd';
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
      backgroundImage: "gradient_clean_white",
      backgroundType: BackgroundType.gradient,
      machineSizes: [
        MachineSize(name: 'Small', minWidth: 50, maxWidth: 200, tolerance: 10),
        MachineSize(
          name: 'Medium',
          minWidth: 200,
          maxWidth: 350,
          tolerance: 10,
        ),
        MachineSize(name: 'Large', minWidth: 350, maxWidth: 500, tolerance: 10),
      ],
      selectedMode: GroupingMode.allCombinations,
      selectedSortType: SortType.sortByWidth,
      measurementUnit: MeasurementUnit.m2,
    );
  }
}
