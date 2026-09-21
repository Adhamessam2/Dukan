import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/core/theme/app_theme.dart';
import 'package:Dukan/core/utils/constants.dart';
import 'package:Dukan/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:Dukan/features/cart/presentation/cubit/cart_state.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/presentation/widgets/home_product_card.dart';

class FakeCartCubit extends Cubit<CartState> implements CartCubit {
  FakeCartCubit() : super(const CartState());

  int? addedProductId;

  @override
  Future<void> addToCart({
    required int productId,
    required int quantity,
  }) async {
    addedProductId = productId;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeCartCubit fakeCartCubit;

  setUp(() {
    fakeCartCubit = FakeCartCubit();
  });

  tearDown(() {
    fakeCartCubit.close();
  });

  Widget buildTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: AppConstants.designSizePortrait,
      builder: (context, _) => MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: BlocProvider<CartCubit>.value(
            value: fakeCartCubit,
            child: SizedBox(width: 200, height: 300, child: child),
          ),
        ),
      ),
    );
  }

  const inStockProduct = ProductEntity(
    id: 1,
    productName: 'Panadol Extra',
    price: 45.0,
    stockQuantity: 10,
  );

  const outOfStockProduct = ProductEntity(
    id: 2,
    productName: 'Aspirin 100mg',
    price: 25.0,
    stockQuantity: 0,
  );

  testWidgets(
    'displays OUT OF STOCK chip and disables add button when stock is 0',
    (tester) async {
      bool addToCartCalled = false;

      await tester.pumpWidget(
        buildTestableWidget(
          HomeProductCard(
            product: outOfStockProduct,
            onAddToCart: () => addToCartCalled = true,
          ),
        ),
      );

      expect(find.text('OUT OF STOCK'), findsOneWidget);

      // Tap add to cart button
      await tester.tap(find.byType(InkWell).last);
      await tester.pump();

      expect(addToCartCalled, isFalse);
      expect(fakeCartCubit.addedProductId, isNull);
    },
  );

  testWidgets(
    'does not display OUT OF STOCK chip and allows adding to cart when in stock',
    (tester) async {
      bool addToCartCalled = false;

      await tester.pumpWidget(
        buildTestableWidget(
          HomeProductCard(
            product: inStockProduct,
            onAddToCart: () => addToCartCalled = true,
          ),
        ),
      );

      expect(find.text('OUT OF STOCK'), findsNothing);

      // Tap add to cart button
      await tester.tap(find.byType(InkWell).last);
      await tester.pump();

      expect(addToCartCalled, isTrue);
    },
  );

  testWidgets(
    'disables add button when another product is being added (CartStatus.loading)',
    (tester) async {
      bool addToCartCalled = false;
      fakeCartCubit.emit(
        const CartState(status: CartStatus.loading, addingProductId: 999),
      );

      await tester.pumpWidget(
        buildTestableWidget(
          HomeProductCard(
            product: inStockProduct,
            onAddToCart: () => addToCartCalled = true,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byType(InkWell).last);
      await tester.pump();

      expect(addToCartCalled, isFalse);
    },
  );

  testWidgets(
    'shows CircularProgressIndicator when this product is being added',
    (tester) async {
      fakeCartCubit.emit(
        const CartState(status: CartStatus.loading, addingProductId: 1),
      );

      await tester.pumpWidget(
        buildTestableWidget(HomeProductCard(product: inStockProduct)),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}
