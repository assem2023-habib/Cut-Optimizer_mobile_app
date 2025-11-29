import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/results/screens/results_screen.dart';
import 'package:cut_optimizer_mobile/models/config.dart';

void main() {
  testWidgets('ResultsScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ResultsScreen(
          groups: const [],
          remaining: const [],
          outputFilePath: '/test/output.xlsx',
          minWidth: 100,
          maxWidth: 200,
          tolerance: 5,
          config: Config.defaultConfig(),
        ),
      ),
    );

    expect(find.text('النتائج'), findsOneWidget);
    // Add more expectations as needed
  });
}
