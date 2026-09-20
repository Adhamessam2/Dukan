import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/usecases/usecase.dart';
import 'package:Dukan/features/cart/domain/entities/cart_entity.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';
import 'package:Dukan/features/cart/domain/repositories/cart_repository.dart';
import 'package:Dukan/features/cart/domain/usecases/clear_cart_use_case.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';

class MockCartRepository implements CartRepository {
  Either<Failure, int>? clearCartResult;
  bool clearCartCalled = false;

  @override
  Future<Either<Failure, int>> clearCart() async {
    clearCartCalled = true;
    return clearCartResult!;
  }

  @override
  Future<Either<Failure, CartItemEntity>> addToCart({
    required int productId,
    required int quantity,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, CartEntity>> getCart() => throw UnimplementedError();

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
}

void main() {
  late ClearCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = ClearCartUseCase(mockRepository);
  });

  test(
    'should call repository.clearCart and return count on success',
    () async {
      mockRepository.clearCartResult = const Right(1);

      final result = await useCase(const NoParams());

      expect(mockRepository.clearCartCalled, isTrue);
      expect(result, const Right(1));
    },
  );

  test('should return Failure when repository.clearCart fails', () async {
    const tFailure = ServerFailure(message: 'Failed to clear cart', code: 500);
    mockRepository.clearCartResult = const Left(tFailure);

    final result = await useCase(const NoParams());

    expect(mockRepository.clearCartCalled, isTrue);
    expect(result, const Left(tFailure));
  });
}
