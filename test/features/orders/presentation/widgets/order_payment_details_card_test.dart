import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_payment_status_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/entities/payment_transaction_entity.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_payment_details_card.dart';

void main() {
  final tOrder = OrderEntity(
    id: 8740,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Zamalek',
    shippingBuilding: '12',
    orderStatus: 'DELIVERED',
    totalAmount: 120.0,
    paymentMethod: PaymentMethod.creditCard,
    createdAt: DateTime(2024, 10, 24),
  );

  final tPaymentStatus = OrderPaymentStatusEntity(
    id: 8740,
    orderStatus: 'DELIVERED',
    totalAmount: 120.0,
    payments: [
      PaymentTransactionEntity(
        id: 'txn_987654321',
        status: 'PAID',
        provider: 'Paymob Gateway',
        updatedAt: DateTime(2024, 10, 24, 14, 30),
      ),
    ],
  );

  Widget buildTestWidget({
    required OrderEntity order,
    OrderPaymentStatusEntity? paymentStatus,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: OrderPaymentDetailsCard(
              order: order,
              paymentStatus: paymentStatus,
            ),
          ),
        ),
      ),
    );
  }

  group('OrderPaymentDetailsCard', () {
    testWidgets(
      'renders payment provider, transaction reference and Paid status',
      (tester) async {
        await tester.pumpWidget(
          buildTestWidget(order: tOrder, paymentStatus: tPaymentStatus),
        );
        await tester.pumpAndSettle();

        expect(find.text('Payment Details'), findsOneWidget);
        expect(find.text('Paid'), findsOneWidget);
        expect(find.text('Paymob Gateway'), findsOneWidget);
        expect(find.text('Ref: #txn_987654321'), findsOneWidget);
        expect(find.byIcon(Icons.shield_outlined), findsWidgets);
      },
    );

    testWidgets('gracefully renders fallback when paymentStatus is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(order: tOrder, paymentStatus: null),
      );
      await tester.pumpAndSettle();

      expect(find.text('Payment Details'), findsOneWidget);
      expect(find.text('Credit Card'), findsOneWidget);
      expect(find.text('Ref: #PMB-8740'), findsOneWidget);
    });
  });
}
