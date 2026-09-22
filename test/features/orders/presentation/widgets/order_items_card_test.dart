import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_item_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_items_card.dart';

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

  final tDeliveredOrder = OrderEntity(
    id: 8740,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Zamalek',
    shippingBuilding: '12',
    orderStatus: 'DELIVERED',
    totalAmount: 158.0,
    paymentMethod: PaymentMethod.creditCard,
    createdAt: DateTime(2024, 10, 24),
    items: const [
      OrderItemEntity(quantity: 1, product: tProduct1),
      OrderItemEntity(quantity: 2, product: tProduct2),
    ],
  );

  Widget buildTestWidget(
    OrderEntity order, {
    ValueChanged<OrderItemEntity>? onBuyAgain,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: OrderItemsCard(
              order: order,
              onBuyAgain: onBuyAgain ?? (_) {},
            ),
          ),
        ),
      ),
    );
  }

  group('OrderItemsCard', () {
    testWidgets(
      'renders items count header badge and product titles with price',
      (tester) async {
        await tester.pumpWidget(buildTestWidget(tDeliveredOrder));
        await tester.pumpAndSettle();

        expect(find.text('Items in Order'), findsOneWidget);
        expect(find.text('2 items'), findsOneWidget);
        expect(find.text('Kinfolk Amber Diffuser'), findsOneWidget);
        expect(find.text('Handcrafted Stoneware'), findsOneWidget);
        expect(find.text('Qty: 1'), findsOneWidget);
        expect(find.text('Qty: 2'), findsOneWidget);
        expect(find.text('\$46.00'), findsOneWidget);
        expect(find.text('\$112.00'), findsOneWidget);
        expect(find.text('Verified Delivery'), findsNWidgets(2));
        expect(find.text('Buy Again'), findsNWidgets(2));
      },
    );

    testWidgets('tapping Buy Again calls onBuyAgain callback with item', (
      tester,
    ) async {
      OrderItemEntity? tappedItem;
      await tester.pumpWidget(
        buildTestWidget(
          tDeliveredOrder,
          onBuyAgain: (item) => tappedItem = item,
        ),
      );
      await tester.pumpAndSettle();

      final buyAgainButtons = find.text('Buy Again');
      await tester.tap(buyAgainButtons.first);
      await tester.pump();

      expect(tappedItem, equals(tDeliveredOrder.items.first));
    });
  });
}
