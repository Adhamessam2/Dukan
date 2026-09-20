import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/cart/domain/entities/cart_entity.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';
import 'package:Dukan/features/cart/domain/repositories/cart_repository.dart';
import 'package:Dukan/features/cart/domain/usecases/delete_cart_item_use_case.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';

class MockCartRepository implements CartRepository {
  Either<Failure, CartItemEntity>? deleteCartItemResult;
  String? calledCartId;
  String? calledProductId;

  @override
  Future<Either<Failure, CartItemEntity>> deleteCartItem({
    required String cartId,
    required String productId,
  }) async {
    calledCartId = cartId;
    calledProductId = productId;
    return deleteCartItemResult!;
  }

  @override
  Future<Either<Failure, CartItemEntity>> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, ProductEntity>> getCartItem({
    required String cartId,
    required String productId,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, CartEntity>> getCart() => throw UnimplementedError();

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, int>> clearCart() => throw UnimplementedError();
}

void main() {
  late DeleteCartItemUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = DeleteCartItemUseCase(mockRepository);
  });

  const tCartItem = CartItemEntity(
    cartId: 1,
    productId: 1,
    quantity: 1,
    isDeleted: false,
  );

  const tParams = DeleteCartItemParams(cartId: '1', productId: '1');

  test(
    'should call repository.deleteCartItem with correct params and return CartItemEntity on success',
    () async {
      mockRepository.deleteCartItemResult = const Right(tCartItem);

      final result = await useCase(tParams);

      expect(mockRepository.calledCartId, equals('1'));
      expect(mockRepository.calledProductId, equals('1'));
      expect(result, const Right(tCartItem));
    },
  );

  test('should return Failure when repository.deleteCartItem fails', () async {
    const tFailure = ServerFailure(
      message: 'Item not found in cart',
      code: 404,
    );
    mockRepository.deleteCartItemResult = const Left(tFailure);

    final result = await useCase(tParams);

    expect(mockRepository.calledCartId, equals('1'));
    expect(mockRepository.calledProductId, equals('1'));
    expect(result, const Left(tFailure));
  });

  test('DeleteCartItemParams props should match values', () {
    const params1 = DeleteCartItemParams(cartId: '1', productId: '1');
    const params2 = DeleteCartItemParams(cartId: '1', productId: '1');
    expect(params1, equals(params2));
  });
}
