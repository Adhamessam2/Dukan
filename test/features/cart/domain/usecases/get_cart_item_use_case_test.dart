import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/cart/domain/entities/cart_entity.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';
import 'package:Dukan/features/cart/domain/repositories/cart_repository.dart';
import 'package:Dukan/features/cart/domain/usecases/get_cart_item_use_case.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';

class MockCartRepository implements CartRepository {
  Either<Failure, ProductEntity>? getCartItemResult;
  String? calledCartId;
  String? calledProductId;

  @override
  Future<Either<Failure, ProductEntity>> getCartItem({
    required String cartId,
    required String productId,
  }) async {
    calledCartId = cartId;
    calledProductId = productId;
    return getCartItemResult!;
  }

  @override
  Future<Either<Failure, CartEntity>> getCart() => throw UnimplementedError();

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
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
  late GetCartItemUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = GetCartItemUseCase(mockRepository);
  });

  const tProduct = ProductEntity(
    id: 1,
    productName: 'Refurbished iPhone 14 Pro',
    price: 9999.99,
  );

  const tParams = GetCartItemParams(cartId: '4', productId: '1');

  test(
    'should call repository.getCartItem with correct params and return ProductEntity on success',
    () async {
      mockRepository.getCartItemResult = const Right(tProduct);

      final result = await useCase(tParams);

      expect(mockRepository.calledCartId, equals('4'));
      expect(mockRepository.calledProductId, equals('1'));
      expect(result, const Right(tProduct));
    },
  );

  test('should return Failure when repository.getCartItem fails', () async {
    const tFailure = ServerFailure(message: 'Server error', code: 500);
    mockRepository.getCartItemResult = const Left(tFailure);

    final result = await useCase(tParams);

    expect(mockRepository.calledCartId, equals('4'));
    expect(mockRepository.calledProductId, equals('1'));
    expect(result, const Left(tFailure));
  });

  test('GetCartItemParams props should match values', () {
    const params1 = GetCartItemParams(cartId: '4', productId: '1');
    const params2 = GetCartItemParams(cartId: '4', productId: '1');
    expect(params1, equals(params2));
  });
}
