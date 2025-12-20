import 'dart:math';

int gcd(int a, int b) {
  while (b != 0) {
    var t = b;
    b = a % b;
    a = t;
  }
  return a;
}

int lcm(int a, int b) {
  if (a == 0 || b == 0) return 0;
  return (a * b).abs() ~/ gcd(a, b);
}

int gcdList(List<int> lst) {
  if (lst.isEmpty) return 0;
  int result = lst[0];
  for (int i = 1; i < lst.length; i++) {
    result = gcd(result, lst[i]);
  }
  return result;
}

int lcmList(List<int> lst) {
  if (lst.isEmpty) return 0;
  int result = lst[0];
  for (int i = 1; i < lst.length; i++) {
    result = lcm(result, lst[i]);
  }
  return result;
}

class EqualProductResult {
  final List<int>? xList;
  final int kMax;

  EqualProductResult(this.xList, this.kMax);
}

EqualProductResult equalProductsSolution(
  List<int> a,
  List<int> xMax, {
  int? maxProduct,
}) {
  int n = a.length;
  if (n == 0 || n != xMax.length) {
    return EqualProductResult(null, 0);
  }
  int g = gcdList(a);
  if (g == 0) {
    return EqualProductResult(null, 0);
  }
  List<int> A = a.map((ai) => ai ~/ g).toList();

  int l = lcmList(A);
  if (l == 0) {
    return EqualProductResult(null, 0);
  }

  List<double> limits = [];
  for (int i = 0; i < n; i++) {
    if (A[i] == 0) {
      limits.add(0);
    } else {
      double limit = (xMax[i] * A[i]) / l;
      limits.add(limit);
    }
  }

  int kMax = limits.isEmpty ? 0 : limits.reduce(min).floor();

  // Apply maxProduct constraint if provided
  if (maxProduct != null && maxProduct > 0) {
    int kFromMaxProduct = maxProduct ~/ (l * g);
    kMax = min(kMax, kFromMaxProduct);
  }

  if (kMax <= 0) {
    return EqualProductResult(null, 0);
  }

  List<int> xList = [];
  for (int Ai in A) {
    int xi = (l * kMax) ~/ Ai;
    xList.add(xi);
  }

  return EqualProductResult(xList, kMax);
}

EqualProductResult equalProductsSolutionWithTolerance(
  List<int> a,
  List<int> xMax,
  int delta, {
  int? maxProduct,
}) {
  int n = a.length;
  if (n == 0 || n != xMax.length) {
    return EqualProductResult(null, 0);
  }
  if (a.any((ai) => ai <= 0)) {
    return EqualProductResult(null, 0);
  }
  if (xMax.any((xm) => xm < 0)) {
    return EqualProductResult(null, 0);
  }
  if (n == 1) {
    int xi = xMax[0];
    if (maxProduct != null && maxProduct > 0) {
      xi = min(xi, maxProduct ~/ a[0]);
    }
    return EqualProductResult([xi], xi);
  }

  int aRef = a[0];
  int x0Max = xMax[0];

  // Apply maxProduct constraint to x0Max
  if (maxProduct != null && maxProduct > 0) {
    int x0FromMaxProduct = maxProduct ~/ aRef;
    x0Max = min(x0Max, x0FromMaxProduct);
  }

  for (int i = 1; i < n; i++) {
    int limit = ((a[i] * xMax[i] + delta) / aRef).floor();
    x0Max = min(x0Max, limit);
  }
  if (x0Max < 0) {
    return EqualProductResult(null, 0);
  }

  for (int x0 = x0Max; x0 >= 0; x0--) {
    int target = aRef * x0;
    List<int> xCandidate = [x0];
    bool valid = true;
    for (int i = 1; i < n; i++) {
      double xiMinRaw = (target - delta) / a[i];
      int xiMin = max(0, xiMinRaw.ceil());

      int xiMax = ((target + delta) / a[i]).floor();
      int xi = min(xiMax, xMax[i]);
      if (xi < xiMin || xi < 0) {
        valid = false;
        break;
      }

      if ((a[i] * xi - target).abs() > delta) {
        valid = false;
        break;
      }

      xCandidate.add(xi);
    }

    if (!valid) {
      continue;
    }

    bool allPairsValid = true;
    for (int i = 0; i < n; i++) {
      for (int j = i + 1; j < n; j++) {
        int diff = (a[i] * xCandidate[i] - a[j] * xCandidate[j]).abs();
        if (diff > delta) {
          allPairsValid = false;
          break;
        }
      }
      if (!allPairsValid) {
        break;
      }
    }
    if (allPairsValid) {
      int kMax = xCandidate[0];
      return EqualProductResult(xCandidate, kMax);
    }
  }
  return EqualProductResult(null, 0);
}
