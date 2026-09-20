import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';
import 'package:Dukan/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';

void main() {
  const tProduct = ProductEntity(
    id: 1,
    productName: 'Nordic Ceramic Mug',
    price: 28.0,
  );

  const tCartItem = CartItemEntity(
    cartId: 4,
    productId: 1,
    quantity: 2,
    product: tProduct,
  );

  Widget buildTestWidget({
    VoidCallback? onIncrement,
    VoidCallback? onDecrement,
    VoidCallback? onRemove,
  }) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: CartItemCard(
            item: tCartItem,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            onRemove: onRemove,
          ),
        ),
      ),
    );
  }

  testWidgets('renders product name, unit price, quantity, and total price', (
    tester,
  ) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.pumpAndSettle();

    expect(find.text('Nordic Ceramic Mug'), findsOneWidget);
    expect(find.text('\$28.00 each'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('\$56.00'), findsOneWidget);
  });

  testWidgets('tapping increment invokes onIncrement callback', (tester) async {
    bool incrementCalled = false;
    await tester.pumpWidget(
      buildTestWidget(onIncrement: () => incrementCalled = true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded));
    expect(incrementCalled, isTrue);
  });

  testWidgets('tapping decrement invokes onDecrement callback', (tester) async {
    bool decrementCalled = false;
    await tester.pumpWidget(
      buildTestWidget(onDecrement: () => decrementCalled = true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.remove_rounded));
    expect(decrementCalled, isTrue);
  });

  testWidgets('tapping remove invokes onRemove callback', (tester) async {
    bool removeCalled = false;
    await tester.pumpWidget(
      buildTestWidget(onRemove: () => removeCalled = true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close_rounded));
    expect(removeCalled, isTrue);
  });
}
