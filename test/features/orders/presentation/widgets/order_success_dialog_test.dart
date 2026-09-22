import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_success_dialog.dart';

void main() {
  final testOrder = OrderEntity(
    id: 12345,
    shippingCity: 'Cairo',
    shippingStreet: 'Tahrir Square',
    shippingBuilding: 'Building 10',
    orderStatus: 'PENDING',
    totalAmount: 185.50,
    paymentMethod: PaymentMethod.cash,
    createdAt: DateTime(2026, 9, 21),
  );

  Widget buildTestWidget({
    VoidCallback? onContinueShopping,
    VoidCallback? onTrackOrders,
  }) {
    return ScreenUtilInit(
      designSize: AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: OrderSuccessDialog(
            order: testOrder,
            onContinueShopping: onContinueShopping,
            onTrackOrders: onTrackOrders,
          ),
        ),
      ),
    );
  }

  testWidgets('renders success dialog contents: title, order id, and amount', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Order Placed Successfully!'), findsOneWidget);
    expect(find.text('#12345'), findsOneWidget);
    expect(find.text('\$185.50'), findsOneWidget);
    expect(find.text('Continue Shopping'), findsOneWidget);
    expect(find.text('Track Orders'), findsOneWidget);
  });

  testWidgets('tapping buttons invokes callbacks', (tester) async {
    bool continueCalled = false;
    bool trackCalled = false;

    await tester.pumpWidget(
      buildTestWidget(
        onContinueShopping: () => continueCalled = true,
        onTrackOrders: () => trackCalled = true,
      ),
    );
    await tester.pumpAndSettle();

    final continueBtn = find.text('Continue Shopping');
    await tester.ensureVisible(continueBtn);
    await tester.pumpAndSettle();
    await tester.tap(continueBtn);
    expect(continueCalled, isTrue);

    final trackBtn = find.text('Track Orders');
    await tester.ensureVisible(trackBtn);
    await tester.pumpAndSettle();
    await tester.tap(trackBtn);
    expect(trackCalled, isTrue);
  });
}
