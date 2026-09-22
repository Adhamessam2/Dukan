import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/widgets/checkout_sticky_bottom_bar.dart';

void main() {
  Widget buildTestWidget({
    double totalPrice = 129.50,
    PaymentMethod paymentMethod = PaymentMethod.cash,
    bool isLoading = false,
    VoidCallback? onSubmitPressed,
  }) {
    return ScreenUtilInit(
      designSize: AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          bottomNavigationBar: CheckoutStickyBottomBar(
            totalPrice: totalPrice,
            paymentMethod: paymentMethod,
            isLoading: isLoading,
            onSubmitPressed: onSubmitPressed,
          ),
        ),
      ),
    );
  }

  testWidgets('renders TOTAL label and price', (tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('TOTAL'), findsOneWidget);
    expect(find.text('\$129.50'), findsOneWidget);
    expect(find.textContaining('\$129.50'), findsNWidgets(2));
  });

  testWidgets('renders Cash dynamic button text when cash is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(paymentMethod: PaymentMethod.cash, totalPrice: 99.00),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pay with Cash – \$99.00'), findsOneWidget);
  });

  testWidgets('renders Card dynamic button text when creditCard is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildTestWidget(
        paymentMethod: PaymentMethod.creditCard,
        totalPrice: 99.00,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pay with Card – \$99.00'), findsOneWidget);
  });

  testWidgets('tapping CTA triggers onSubmitPressed callback', (tester) async {
    bool submitted = false;
    await tester.pumpWidget(
      buildTestWidget(onSubmitPressed: () => submitted = true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Pay with Cash – \$129.50'));
    await tester.pumpAndSettle();

    expect(submitted, isTrue);
  });

  testWidgets('shows loading indicator when isLoading is true', (tester) async {
    await tester.pumpWidget(buildTestWidget(isLoading: true));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
