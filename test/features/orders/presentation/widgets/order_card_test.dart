import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_item_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_info_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_card.dart';

void main() {
  const tProduct1 = ProductEntity(
    id: 1,
    productName: 'Kinfolk Amber Diffuser',
    price: 46.0,
  );
  const tProduct2 = ProductEntity(
    id: 2,
    productName: 'Handcrafted Stoneware',
    price: 56.0,
  );

  final tOrder = OrderEntity(
    id: 8740,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Zamalek',
    shippingBuilding: '12',
    orderStatus: 'PENDING',
    totalAmount: 46.0,
    paymentMethod: PaymentMethod.cash,
    createdAt: DateTime(2024, 11, 12),
    items: const [OrderItemEntity(quantity: 1, product: tProduct1)],
  );

  final tMultiItemOrder = OrderEntity(
    id: 8921,
    userId: 1,
    shippingCity: 'Giza',
    shippingStreet: 'Pyramids',
    shippingBuilding: '5',
    orderStatus: 'DELIVERED',
    totalAmount: 112.0,
    paymentMethod: PaymentMethod.creditCard,
    createdAt: DateTime(2024, 10, 24),
    items: const [
      OrderItemEntity(quantity: 1, product: tProduct1),
      OrderItemEntity(quantity: 2, product: tProduct2),
    ],
  );

  Widget buildTestWidget(
    OrderEntity order, {
    ValueChanged<OrderEntity>? onViewDetails,
    ValueChanged<OrderEntity>? onPayNow,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: OrderCard(
              order: order,
              onViewDetails: onViewDetails ?? (_) {},
              onPayNow: onPayNow,
            ),
          ),
        ),
      ),
    );
  }

  group('OrderCard', () {
    testWidgets(
      'renders single-item order header, status chip, price and details',
      (tester) async {
        await tester.pumpWidget(buildTestWidget(tOrder));
        await tester.pumpAndSettle();

        expect(find.text('#DK-8740'), findsOneWidget);
        expect(find.text('In Progress'), findsOneWidget);
        expect(find.text('\$46.00'), findsOneWidget);
        expect(find.text('View Details'), findsOneWidget);
        expect(find.text('1 item'), findsOneWidget);
        expect(find.text('Kinfolk Amber Diffuser'), findsWidgets);
      },
    );

    testWidgets(
      'renders multi-item delivered order with Delivered status chip',
      (tester) async {
        await tester.pumpWidget(buildTestWidget(tMultiItemOrder));
        await tester.pumpAndSettle();

        expect(find.text('#DK-8921'), findsOneWidget);
        expect(find.text('Delivered'), findsOneWidget);
        expect(find.text('\$112.00'), findsOneWidget);
        expect(find.text('Delivered to Address'), findsOneWidget);
        expect(find.text('Giza'), findsOneWidget);
      },
    );

    testWidgets(
      'tapping View Details triggers onViewDetails callback with the order',
      (tester) async {
        OrderEntity? selectedOrder;
        await tester.pumpWidget(
          buildTestWidget(
            tOrder,
            onViewDetails: (order) => selectedOrder = order,
          ),
        );
        await tester.pumpAndSettle();

        final viewDetailsBtn = find.text('View Details');
        expect(viewDetailsBtn, findsOneWidget);
        await tester.tap(viewDetailsBtn);
        await tester.pump();

        expect(selectedOrder, equals(tOrder));
      },
    );

    testWidgets(
      'renders plural "items" for single-line-item order when quantity > 1',
      (tester) async {
        final orderWithMultipleQuantity = tOrder.copyWith(
          items: const [OrderItemEntity(quantity: 3, product: tProduct1)],
        );
        await tester.pumpWidget(buildTestWidget(orderWithMultipleQuantity));
        await tester.pumpAndSettle();

        expect(find.text('3 items'), findsOneWidget);
      },
    );

    testWidgets(
      'renders Payment Pending chip and Pay Now button when creditCard order is pending',
      (tester) async {
        OrderEntity? payNowOrder;
        final pendingCreditCardOrder = tOrder.copyWith(
          paymentMethod: PaymentMethod.creditCard,
          payment: const PaymentInfoEntity(
            checkoutUrl: 'https://checkout.stripe.com/pay/cs_test_123',
            clientSecret: 'secret_123',
          ),
        );

        await tester.pumpWidget(
          buildTestWidget(
            pendingCreditCardOrder,
            onPayNow: (order) => payNowOrder = order,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Payment Pending'), findsOneWidget);
        final payNowBtn = find.text('Pay Now');
        expect(payNowBtn, findsOneWidget);

        await tester.tap(payNowBtn);
        await tester.pump();

        expect(payNowOrder, equals(pendingCreditCardOrder));
      },
    );
  });
}
