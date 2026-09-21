import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_details_summary_card.dart';

void main() {
  final tOrder = OrderEntity(
    id: 8740,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Zamalek',
    shippingBuilding: '12',
    orderStatus: 'DELIVERED',
    totalAmount: 148.50,
    paymentMethod: PaymentMethod.creditCard,
    createdAt: DateTime(2024, 10, 24),
  );

  Widget buildTestWidget(OrderEntity order) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: OrderDetailsSummaryCard(order: order),
          ),
        ),
      ),
    );
  }

  group('OrderDetailsSummaryCard', () {
    testWidgets(
      'renders subtotal, shipping free promo, taxes, and total paid',
      (tester) async {
        await tester.pumpWidget(buildTestWidget(tOrder));
        await tester.pumpAndSettle();

        expect(find.text('Order Summary'), findsOneWidget);
        expect(find.text('Subtotal'), findsOneWidget);
        expect(
          find.text('\$148.50'),
          findsNWidgets(2),
        ); // Subtotal & Total Paid
        expect(find.text('Standard Shipping'), findsOneWidget);
        expect(find.text('FREE'), findsOneWidget);
        expect(find.text('Promo'), findsOneWidget);
        expect(find.text('Estimated Tax'), findsOneWidget);
        expect(find.text('Total Paid'), findsOneWidget);
        expect(find.text('Includes all taxes & delivery fees'), findsOneWidget);
      },
    );
  });
}
