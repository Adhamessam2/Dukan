import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/domain/usecases/get_product_by_id_use_case.dart';
import 'package:Dukan/features/product_details/domain/repositories/product_details_repository.dart';

class MockProductDetailsRepository implements ProductDetailsRepository {
  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    return const Right(
      ProductEntity(id: 1, productName: 'Test Product', price: 100.0),
    );
  }
}

void main() {
  test(
    're-exported GetProductByIdUseCase successfully delegates to ProductDetailsRepository',
    () async {
      final repository = MockProductDetailsRepository();
      final useCase = GetProductByIdUseCase(repository);

      final result = await useCase(1);

      expect(result.isRight(), isTrue);
      result.fold(
        (failure) => fail('Should have succeeded'),
        (product) {
          expect(product.id, 1);
          expect(product.productName, 'Test Product');
        },
      );
    },
  );
}
