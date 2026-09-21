import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/widgets/payment_method_card.dart';

void main() {
  Widget buildTestWidget({
    PaymentMethod selectedMethod = PaymentMethod.cash,
    ValueChanged<PaymentMethod>? onMethodSelected,
  }) {
    return ScreenUtilInit(
      designSize: AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: PaymentMethodCard(
              selectedMethod: selectedMethod,
              onMethodSelected: onMethodSelected ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'renders Payment Method title, Secured badge, and selectable tiles',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Payment Method'), findsOneWidget);
      expect(find.text('Secured'), findsOneWidget);
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Visa'), findsOneWidget);
      expect(
        find.text(
          'Encrypted with 256-bit SSL and processed securely via Paymob payment gateways.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'tapping Visa calls onMethodSelected with PaymentMethod.creditCard',
    (tester) async {
      PaymentMethod? chosen;
      await tester.pumpWidget(
        buildTestWidget(
          selectedMethod: PaymentMethod.cash,
          onMethodSelected: (m) => chosen = m,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Visa'));
      await tester.pumpAndSettle();

      expect(chosen, PaymentMethod.creditCard);
    },
  );

  testWidgets('tapping Cash calls onMethodSelected with PaymentMethod.cash', (
    tester,
  ) async {
    PaymentMethod? chosen;
    await tester.pumpWidget(
      buildTestWidget(
        selectedMethod: PaymentMethod.creditCard,
        onMethodSelected: (m) => chosen = m,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cash'));
    await tester.pumpAndSettle();

    expect(chosen, PaymentMethod.cash);
  });
}
