import '../models/carpet.dart';

class CombinationUtils {
  /// Generate combinations of size n from the list.
  static Iterable<List<T>> combinations<T>(List<T> items, int n) sync* {
    if (n == 0) {
      yield [];
      return;
    }
    for (int i = 0; i < items.length; i++) {
      T element = items[i];
      Iterable<List<T>> remaining = combinations(items.sublist(i + 1), n - 1);
      for (List<T> next in remaining) {
        yield [element, ...next];
      }
    }
  }

  /// Generate combinations with replacement of size n from the list.
  static Iterable<List<T>> combinationsWithReplacement<T>(
      List<T> items, int n) sync* {
    if (n == 0) {
      yield [];
      return;
    }
    for (int i = 0; i < items.length; i++) {
      T element = items[i];
      // Pass the list starting from current index to allow repetition
      Iterable<List<T>> remaining =
          combinationsWithReplacement(items.sublist(i), n - 1);
      for (List<T> next in remaining) {
        yield [element, ...next];
      }
    }
  }

  static Iterable<List<Carpet>> generateCombinations(
      List<Carpet> candidates, int n) sync* {
    for (var combo in combinations(candidates, n)) {
      yield combo;
    }
  }

  static Iterable<List<Carpet>> generateCombinationsWithRepetition(
      List<Carpet> candidates, int n) sync* {
    for (var combo in combinationsWithReplacement(candidates, n)) {
      // Check validity based on rem_qty
      Map<int, int> counts = {};
      for (var c in combo) {
        counts[c.id] = (counts[c.id] ?? 0) + 1;
      }

      bool valid = true;
      for (var entry in counts.entries) {
        int cid = entry.key;
        int cnt = entry.value;
        Carpet? carpet = candidates.firstWhere((c) => c.id == cid,
            orElse: () => throw Exception("Carpet not found"));
        if (carpet.remQty < cnt) {
          valid = false;
          break;
        }
      }
      if (valid) {
        yield combo;
      }
    }
  }

  static Iterable<List<Carpet>> generateCombinationsExcludeMain(
      List<Carpet> candidates, int n, Carpet main) sync* {
    List<Carpet> filteredCandidates = candidates
        .where((c) =>
            c.id != main.id && c.isAvailable && c.width != main.width)
        .toList();

    for (var combo in combinations(filteredCandidates, n)) {
      yield combo;
    }
  }

  static Iterable<List<Carpet>> generateCombinationsWithRepetitionExcludeMain(
      List<Carpet> candidates, int n, Carpet main) sync* {
    List<Carpet> filteredCandidates = candidates
        .where((c) =>
            c.id != main.id && c.isAvailable && c.width != main.width)
        .toList();

    for (var combo
        in combinationsWithReplacement(filteredCandidates, n)) {
      Map<int, int> counts = {};
      for (var c in combo) {
        counts[c.id] = (counts[c.id] ?? 0) + 1;
      }

      bool valid = true;
      for (var entry in counts.entries) {
        int cid = entry.key;
        int cnt = entry.value;
        Carpet? carpet = filteredCandidates.firstWhere((c) => c.id == cid,
            orElse: () => throw Exception("Carpet not found"));
        if (carpet.remQty < cnt) {
          valid = false;
          break;
        }
      }
      if (valid) {
        yield combo;
      }
    }
  }

  static List<List<Carpet>> generateValidPartnerCombinations({
    required Carpet main,
    required List<Carpet> candidates,
    required int n,
    required int minWidth,
    required int maxWidth,
    bool allowRepetition = false,
    int startIndex = 0,
    bool excludeMain = false,
  }) {
    List<List<Carpet>> validGroup = [];
    
    // Safety check for start index
    if (startIndex < 0 || startIndex >= candidates.length) {
       // If start index is out of bounds, we might still have valid candidates if we are just filtering
       // But based on python logic: candidates[start_index:]
       if (startIndex >= candidates.length) return [];
    }

    List<Carpet> filteredCandidates = candidates
        .sublist(startIndex)
        .where((c) => c.isAvailable && (main.width + c.width) <= maxWidth)
        .toList();

    if (filteredCandidates.isEmpty) {
      return validGroup;
    }

    Iterable<List<Carpet>> iterator;

    if (allowRepetition) {
      if (excludeMain) {
        iterator = generateCombinationsWithRepetitionExcludeMain(
            filteredCandidates, n, main);
      } else {
        iterator =
            generateCombinationsWithRepetition(filteredCandidates, n);
      }
    } else {
      if (excludeMain) {
        iterator =
            generateCombinationsExcludeMain(filteredCandidates, n, main);
      } else {
        iterator = generateCombinations(filteredCandidates, n);
      }
    }

    for (var partners in iterator) {
      int totalWidth =
          main.width + partners.fold(0, (sum, p) => sum + p.width);
      if (minWidth <= totalWidth && totalWidth <= maxWidth) {
        validGroup.add(partners);
      }
    }
    return validGroup;
  }
}
