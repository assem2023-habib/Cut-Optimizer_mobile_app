import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/grouping_mode/screens/grouping_mode_screen.dart';
import 'package:cut_optimizer_mobile/core/widgets/radio_option_tile.dart';
import 'package:cut_optimizer_mobile/core/enums.dart';

void main() {
  testWidgets('GroupingModeScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GroupingModeScreen()));

    expect(find.text('GROUPING MODE'), findsOneWidget);
    expect(find.byType(RadioOptionTile<GroupingMode>), findsNWidgets(2));
    expect(find.text('all combinations'), findsOneWidget);
    expect(find.text('combinations rep exclude main'), findsOneWidget);
    expect(find.text('Next >'), findsOneWidget);
  });
}
