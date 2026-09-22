import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_item_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_fulfillment_card.dart';

void main() {
  const tProduct = ProductEntity(
    id: 1,
    productName: 'Kinfolk Amber Diffuser',
    price: 46.0,
  );

  final tDeliveredOrder = OrderEntity(
    id: 8740,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Zamalek',
    shippingBuilding: '12',
    orderStatus: 'DELIVERED',
    totalAmount: 46.0,
    paymentMethod: PaymentMethod.creditCard,
    createdAt: DateTime(2024, 10, 24),
    updatedAt: DateTime(2024, 10, 27),
    items: const [OrderItemEntity(quantity: 1, product: tProduct)],
  );

  final tPendingOrder = OrderEntity(
    id: 8741,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Zamalek',
    shippingBuilding: '12',
    orderStatus: 'PENDING',
    totalAmount: 46.0,
    paymentMethod: PaymentMethod.cash,
    createdAt: DateTime(2024, 11, 12),
    items: const [OrderItemEntity(quantity: 1, product: tProduct)],
  );

  final tCancelledOrder = OrderEntity(
    id: 8742,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Zamalek',
    shippingBuilding: '12',
    orderStatus: 'CANCELLED',
    totalAmount: 46.0,
    paymentMethod: PaymentMethod.cash,
    createdAt: DateTime(2024, 11, 10),
    items: const [OrderItemEntity(quantity: 1, product: tProduct)],
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
            child: OrderFulfillmentCard(order: order),
          ),
        ),
      ),
    );
  }

  group('OrderFulfillmentCard', () {
    testWidgets(
      'renders delivered status with formatted date and semantic chip',
      (tester) async {
        await tester.pumpWidget(buildTestWidget(tDeliveredOrder));
        await tester.pumpAndSettle();

        expect(find.text('FULFILLMENT STATUS'), findsOneWidget);
        expect(find.text('Delivered on Oct 27, 2024'), findsOneWidget);
        expect(find.text('Delivered'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_rounded), findsWidgets);
      },
    );

    testWidgets('renders pending status with Order Pending headline', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(tPendingOrder));
      await tester.pumpAndSettle();

      expect(find.text('FULFILLMENT STATUS'), findsOneWidget);
      expect(find.text('Order Pending'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.byIcon(Icons.access_time_rounded), findsWidgets);
    });

    testWidgets('renders cancelled status with Order Cancelled headline', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget(tCancelledOrder));
      await tester.pumpAndSettle();

      expect(find.text('FULFILLMENT STATUS'), findsOneWidget);
      expect(find.text('Order Cancelled'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.byIcon(Icons.cancel_rounded), findsWidgets);
    });
  });
}
