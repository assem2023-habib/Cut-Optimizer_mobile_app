import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/sorting_options/screens/sorting_options_screen.dart';
import 'package:cut_optimizer_mobile/features/sorting_options/widgets/sorting_option_tile.dart';

void main() {
    expect(find.text('Sort carpet by width'), findsOneWidget);
    expect(find.text('Sort carpet by height'), findsOneWidget);
    expect(find.text('Next >'), findsOneWidget);
  });
}
