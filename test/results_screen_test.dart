import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/results/screens/results_screen.dart';

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
        ),
      ),
    );

    expect(find.text('PROCESSING COMPLETE'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.text('Share Results'), findsOneWidget);
    expect(find.text('New Process'), findsOneWidget);
  });
}
