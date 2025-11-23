import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/set_constraints/screens/set_constraints_screen.dart';
import 'package:cut_optimizer_mobile/features/set_constraints/widgets/custom_text_field.dart';

void main() {
  testWidgets('SetConstraintsScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SetConstraintsScreen(filePath: '/test/file.xlsx'),
      ),
    );

    expect(find.text('SET CONSTRAINTS'), findsOneWidget);
    expect(find.byType(CustomTextField), findsNWidgets(3));
    expect(find.text('Max Width'), findsOneWidget);
    expect(find.text('Min Width'), findsOneWidget);
    expect(find.text('Tolerance'), findsOneWidget);
    expect(find.text('Next >'), findsOneWidget);
  });
}
