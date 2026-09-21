import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/features/orders/presentation/widgets/checkout_step_indicator.dart';

void main() {
  testWidgets('CheckoutStepIndicator renders title, step badge, and subtitle', (
    tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: AppConstants.designSizePortrait,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: CheckoutStepIndicator()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Final Step'), findsOneWidget);
    expect(find.text('Step 2 of 2'), findsOneWidget);
    expect(
      find.text('Review your shipping details & confirm payment'),
      findsOneWidget,
    );
  });
}
