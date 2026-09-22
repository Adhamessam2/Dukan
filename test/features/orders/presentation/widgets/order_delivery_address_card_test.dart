import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_delivery_address_card.dart';

void main() {
  final tOrder = OrderEntity(
    id: 8740,
    userId: 1,
    shippingCity: 'Cairo',
    shippingStreet: 'Zamalek Street',
    shippingBuilding: '12B',
    orderStatus: 'DELIVERED',
    totalAmount: 120.0,
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
        home: Scaffold(body: OrderDeliveryAddressCard(order: order)),
      ),
    );
  }

  group('OrderDeliveryAddressCard', () {
    testWidgets('renders address fields and location icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(tOrder));
      await tester.pumpAndSettle();

      expect(find.text('Delivery Address'), findsOneWidget);
      expect(find.text('Building 12B'), findsOneWidget);
      expect(find.text('Zamalek Street'), findsOneWidget);
      expect(find.text('Cairo'), findsOneWidget);
      expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);
    });
  });
}
