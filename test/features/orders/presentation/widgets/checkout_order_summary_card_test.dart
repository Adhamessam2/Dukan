import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/features/cart/domain/entities/cart_entity.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/orders/presentation/widgets/checkout_order_summary_card.dart';

void main() {
  const tProduct1 = ProductEntity(
    id: 1,
    productName: 'Nordic Ceramic Mug',
    price: 28.0,
  );
  const tProduct2 = ProductEntity(
    id: 2,
    productName: 'Minimalist Desk Lamp',
    price: 45.0,
  );

  const tCart = CartEntity(
    id: 1,
    items: [
      CartItemEntity(cartId: 1, productId: 1, quantity: 2, product: tProduct1),
      CartItemEntity(cartId: 1, productId: 2, quantity: 1, product: tProduct2),
    ],
    totalPrice: 101.0,
  );

  Widget buildTestWidget({CartEntity? cart}) {
    return ScreenUtilInit(
      designSize: AppConstants.designSizePortrait,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            child: CheckoutOrderSummaryCard(cart: cart ?? tCart),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'renders header with title, shopping bag icon, and item count badge',
    (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.text('2 Items'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
    },
  );

  testWidgets('renders horizontal preview thumbnails with quantity pills', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('2x'), findsOneWidget);
    expect(find.text('1x'), findsOneWidget);
  });

  testWidgets('renders shipping estimate and financial breakdown', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Standard Shipping'), findsNWidgets(2)); // Row & line item
    expect(find.text('Est. 2–3 days'), findsOneWidget);
    expect(find.text('Items Subtotal'), findsOneWidget);
    expect(find.text('\$101.00'), findsNWidgets(2)); // Subtotal & Total
    expect(find.text('FREE'), findsOneWidget);
    expect(find.text('Estimated Sales Tax'), findsOneWidget);
    expect(find.text('Total Payable'), findsOneWidget);
  });
}
