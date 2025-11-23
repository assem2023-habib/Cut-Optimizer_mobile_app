import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/results/screens/results_screen.dart';

void main() {
  testWidgets('ResultsScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ResultsScreen()));

    expect(find.text('PROCESSING COMPLETE'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    expect(find.byType(DataTable), findsOneWidget);
    expect(find.text('Group ID'), findsOneWidget);
    expect(find.text('Export to Excel'), findsOneWidget);
    expect(find.text('Open File'), findsOneWidget);
  });
}
