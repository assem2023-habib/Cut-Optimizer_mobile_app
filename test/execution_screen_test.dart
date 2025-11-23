import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/execution/screens/execution_screen.dart';
import 'package:cut_optimizer_mobile/core/enums.dart';

void main() {
  testWidgets('ExecutionScreen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ExecutionScreen(
          filePath: '/test/file.xlsx',
          minWidth: 50,
          maxWidth: 400,
          tolerance: 5,
          sortType: SortType.sortByWidth,
          groupingMode: GroupingMode.allCombinations,
        ),
      ),
    );

    expect(find.text('READY TO EXECUTE'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('0%'), findsOneWidget);
    expect(find.text('Start Execution'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });
}
