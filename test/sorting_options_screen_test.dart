import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/sorting_options/screens/sorting_options_screen.dart';
import 'package:cut_optimizer_mobile/features/sorting_options/widgets/sorting_option_tile.dart';

void main() {
  testWidgets('SortingOptionsScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SortingOptionsScreen()));

    expect(find.text('SORTING OPTIONS'), findsOneWidget);
    expect(find.byType(SortingOptionTile), findsNWidgets(3));
    expect(find.text('Sort carpet by quantity'), findsOneWidget);
    expect(find.text('Sort carpet by width'), findsOneWidget);
    expect(find.text('Sort carpet by height'), findsOneWidget);
    expect(find.text('Next >'), findsOneWidget);
  });
}
