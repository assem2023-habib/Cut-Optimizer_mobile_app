import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/grouping_mode/screens/grouping_mode_screen.dart';
import 'package:cut_optimizer_mobile/core/widgets/radio_option_tile.dart';
import 'package:cut_optimizer_mobile/core/enums.dart';

void main() {
    expect(find.text('all combinations'), findsOneWidget);
    expect(find.text('combinations rep exclude main'), findsOneWidget);
    expect(find.text('Next >'), findsOneWidget);
  });
}
