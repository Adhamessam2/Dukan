import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/cart/domain/entities/cart_entity.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';
import 'package:Dukan/features/cart/domain/repositories/cart_repository.dart';
import 'package:Dukan/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';

class MockCartRepository implements CartRepository {
  Either<Failure, CartItemEntity>? result;
  Either<Failure, CartEntity>? getCartResult;
  int? calledProductId;
  int? calledQuantity;

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) async {
    calledProductId = productId;
    calledQuantity = quantity;
    return result!;
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    return getCartResult!;
  }

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
  late AddToCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = AddToCartUseCase(mockRepository);
  });

  const tCartItem = CartItemEntity(
    cartId: 1,
    productId: 1,
    quantity: 1,
    isDeleted: false,
  );

  const tParams = AddToCartParams(productId: 1, quantity: 1);

  test(
    'should call repository.addToCart and return CartItemEntity on success',
    () async {
      mockRepository.result = const Right(tCartItem);

      final result = await useCase(tParams);

      expect(mockRepository.calledProductId, equals(1));
      expect(mockRepository.calledQuantity, equals(1));
      expect(result, const Right(tCartItem));
    },
  );

  test('should return Failure when repository fails', () async {
    const tFailure = ServerFailure(message: 'Server error', code: 500);
    mockRepository.result = const Left(tFailure);

    final result = await useCase(tParams);

    expect(mockRepository.calledProductId, equals(1));
    expect(mockRepository.calledQuantity, equals(1));
    expect(result, const Left(tFailure));
  });
}
