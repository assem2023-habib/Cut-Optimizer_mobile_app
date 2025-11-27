import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cut_optimizer_mobile/features/set_constraints/screens/set_constraints_screen.dart';
import 'package:cut_optimizer_mobile/features/set_constraints/widgets/custom_text_field.dart';

    expect(find.text('Min Width'), findsOneWidget);
    expect(find.text('Tolerance'), findsOneWidget);
    expect(find.text('Next >'), findsOneWidget);
  });
}
