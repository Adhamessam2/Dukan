import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/widgets/custom_text_field.dart';

void main() {
  testWidgets(
    'CustomTextField renders label, hint, prefix, suffix, and handles onTap when readOnly',
    (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: CustomTextField(
                label: 'Test Label',
                hint: 'Test Hint',
                readOnly: true,
                onTap: () => tapped = true,
                prefixIcon: const Icon(Icons.email),
                suffixIcon: const Icon(Icons.visibility),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('Test Hint'), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);

      await tester.tap(find.byType(TextFormField));
      expect(tapped, isTrue);
    },
  );
}
