import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/presentation/widgets/order_details_header.dart';

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

  Widget buildTestWidget({VoidCallback? onInvoicePressed}) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: OrderDetailsHeader(
            order: tOrder,
            onInvoicePressed: onInvoicePressed,
          ),
        ),
      ),
    );
  }

  group('OrderDetailsHeader', () {
    testWidgets('renders order ID and invoice button', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('#DK-8740'), findsOneWidget);
      expect(find.text('Invoice'), findsOneWidget);
      expect(find.byIcon(Icons.download_rounded), findsOneWidget);
    });

    testWidgets('tapping invoice button triggers callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTestWidget(onInvoicePressed: () => tapped = true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Invoice'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
