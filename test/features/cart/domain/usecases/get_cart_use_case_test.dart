import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/usecases/usecase.dart';
import 'package:Dukan/features/cart/domain/entities/cart_entity.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';
import 'package:Dukan/features/cart/domain/repositories/cart_repository.dart';
import 'package:Dukan/features/cart/domain/usecases/get_cart_use_case.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';

class MockCartRepository implements CartRepository {
  Either<Failure, CartEntity>? getCartResult;
  bool getCartCalled = false;

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    getCartCalled = true;
    return getCartResult!;
  }

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, ProductEntity>> getCartItem({
    required String cartId,
    required String productId,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, CartItemEntity>> deleteCartItem({
    required String cartId,
    required String productId,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, int>> clearCart() => throw UnimplementedError();
}

void main() {
  late GetCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = GetCartUseCase(mockRepository);
  });

  const tProduct = ProductEntity(
    id: 1,
    productName: 'Refurbished iPhone 14 Pro',
    price: 9999.99,
  );

  const tCartItem = CartItemEntity(
    productId: 1,
    quantity: 3,
    product: tProduct,
  );

  const tCart = CartEntity(id: 4, items: [tCartItem], totalPrice: 29999.97);

  test(
    'should call repository.getCart and return CartEntity on success',
    () async {
      mockRepository.getCartResult = const Right(tCart);

      final result = await useCase(const NoParams());

      expect(mockRepository.getCartCalled, isTrue);
      expect(result, const Right(tCart));
    },
  );

  test('should return Failure when repository.getCart fails', () async {
    const tFailure = ServerFailure(message: 'Server error', code: 500);
    mockRepository.getCartResult = const Left(tFailure);

    final result = await useCase(const NoParams());

    expect(mockRepository.getCartCalled, isTrue);
    expect(result, const Left(tFailure));
  });
}
