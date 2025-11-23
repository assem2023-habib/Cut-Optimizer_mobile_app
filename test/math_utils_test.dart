import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/core/math_utils.dart';

void main() {
  group('Math Utils Tests', () {
    test('GCD', () {
      expect(gcd(12, 18), 6);
      expect(gcd(0, 5), 5);
      expect(gcd(7, 13), 1);
    });

    test('LCM', () {
      expect(lcm(4, 6), 12);
      expect(lcm(5, 7), 35);
    });

    test('GCD List', () {
      expect(gcdList([12, 18, 24]), 6);
      expect(gcdList([5, 10, 15]), 5);
    });

    test('LCM List', () {
      expect(lcmList([2, 3, 4]), 12);
      expect(lcmList([5, 10, 15]), 30);
    });

    test('Equal Products Solution', () {
      // Example: a=[2, 3], Xmax=[10, 10]
      // LCM(2,3) = 6. 
      // Limits: (10*2)/6 = 3.33, (10*3)/6 = 5.
      // k_max = 3.
      // x1 = (6*3)/2 = 9.
      // x2 = (6*3)/3 = 6.
      // 2*9 = 18, 3*6 = 18.
      var result = equalProductsSolution([2, 3], [10, 10]);
      expect(result.kMax, 3);
      expect(result.xList, [9, 6]);
    });
    
    test('Equal Products Solution With Tolerance', () {
        // Example where exact match is not possible but within tolerance it is.
        // a=[10, 11], Xmax=[10, 10], delta=1
        // target ~ 10*x0.
        // The algorithm prioritizes larger x0, so it starts from max possible.
        // x0=10. target=100.
        // x1 range for 11: (99)/11 to (101)/11 -> 9 to 9. x1=9.
        // 11*9 = 99. |99-100| = 1. Valid.
        // So [10, 9] is the first valid solution found.
        var result = equalProductsSolutionWithTolerance([10, 11], [10, 10], 1);
        expect(result.xList, isNotNull);
        expect(result.xList, [10, 9]);
    });
  });
}
