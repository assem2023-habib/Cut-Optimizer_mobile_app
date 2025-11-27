import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/execution/screens/execution_screen.dart';
import 'package:cut_optimizer_mobile/core/enums.dart';
    expect(find.text('Start Execution'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.close), findsOneWidget);
  });
}
