import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/select_file/screens/select_file_screen.dart';
import 'package:cut_optimizer_mobile/features/select_file/widgets/upload_box.dart';

void main() {
  testWidgets('SelectFileScreen renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SelectFileScreen()));

    expect(find.text('SELECT EXCEL FILE'), findsOneWidget);
    expect(find.byType(UploadBox), findsOneWidget);
    expect(find.text('Upload Excel File'), findsOneWidget);
    expect(find.text('or select from device'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
  });
}
