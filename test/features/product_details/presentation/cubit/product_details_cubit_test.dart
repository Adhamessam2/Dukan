import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/home/domain/entities/category_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_entity.dart';
import 'package:Dukan/features/home/domain/entities/product_image_entity.dart';
import 'package:Dukan/features/product_details/domain/repositories/product_details_repository.dart';
import 'package:Dukan/features/product_details/domain/usecases/get_product_by_id_use_case.dart';
import 'package:Dukan/features/product_details/presentation/cubit/product_details_cubit.dart';
import 'package:Dukan/features/product_details/presentation/cubit/product_details_state.dart';

class MockProductDetailsRepository implements ProductDetailsRepository {
  Either<Failure, ProductEntity>? productResult;

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    return productResult!;
  }
}

void main() {
  late ProductDetailsCubit cubit;
  late MockProductDetailsRepository mockRepository;
  late GetProductByIdUseCase getProductByIdUseCase;

  const tCategory = CategoryEntity(id: 1, categoryName: 'Electronics');
  const tImages = [
    ProductImageEntity(id: 'img1', productId: 1, url: 'https://example.com/1.jpg'),
    ProductImageEntity(id: 'img2', productId: 1, url: 'https://example.com/2.jpg'),
  ];
  const tProduct = ProductEntity(
    id: 1,
    productName: 'iPhone 14 Pro',
    price: 999.0,
    stockQuantity: 3,
    avgRating: 4.5,
    totalReviews: 2,
    category: tCategory,
    productImages: tImages,
  );

  setUp(() {
    mockRepository = MockProductDetailsRepository();
    getProductByIdUseCase = GetProductByIdUseCase(mockRepository);
    cubit = ProductDetailsCubit(getProductByIdUseCase: getProductByIdUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state, const ProductDetailsState());
  });

  test('loadProductDetails with initialProduct emits success immediately then updates', () async {
    mockRepository.productResult = const Right(tProduct);

    await cubit.loadProductDetails(1, initialProduct: tProduct);

    expect(cubit.state.status, ProductDetailsStatus.success);
    expect(cubit.state.product, tProduct);
    expect(cubit.state.quantity, 1);
  });

  test('loadProductDetails with out of stock initialProduct sets quantity to 0', () async {
    const outOfStockProduct = ProductEntity(
      id: 2,
      productName: 'Out of stock item',
      price: 100.0,
      stockQuantity: 0,
      avgRating: 0.0,
      totalReviews: 0,
    );
    mockRepository.productResult = const Right(outOfStockProduct);

    await cubit.loadProductDetails(2, initialProduct: outOfStockProduct);

    expect(cubit.state.status, ProductDetailsStatus.success);
    expect(cubit.state.product, outOfStockProduct);
    expect(cubit.state.quantity, 0);
  });

  test('loadProductDetails without initialProduct emits loading then success', () async {
    mockRepository.productResult = const Right(tProduct);

    final future = cubit.loadProductDetails(1);
    expect(cubit.state.status, ProductDetailsStatus.loading);

    await future;
    expect(cubit.state.status, ProductDetailsStatus.success);
    expect(cubit.state.product, tProduct);
  });

  test('loadProductDetails failure without initialProduct emits failure state', () async {
    mockRepository.productResult =
        const Left(ServerFailure(message: 'Product not found', code: 404));

    await cubit.loadProductDetails(1);

    expect(cubit.state.status, ProductDetailsStatus.failure);
    expect(cubit.state.errorMessage, 'Product not found');
  });

  test('loadProductDetails failure with initialProduct emits errorMessage but keeps product and success status', () async {
    mockRepository.productResult =
        const Left(ServerFailure(message: 'Network error', code: 500));

    await cubit.loadProductDetails(1, initialProduct: tProduct);

    expect(cubit.state.status, ProductDetailsStatus.success);
    expect(cubit.state.product, tProduct);
    expect(cubit.state.errorMessage, 'Network error');
  });

  test('incrementQuantity increases quantity up to stock quantity', () async {
    mockRepository.productResult = const Right(tProduct);
    await cubit.loadProductDetails(1, initialProduct: tProduct);

    expect(cubit.state.quantity, 1);
    cubit.incrementQuantity();
    expect(cubit.state.quantity, 2);
    cubit.incrementQuantity();
    expect(cubit.state.quantity, 3);
    // Should not exceed stock (3)
    cubit.incrementQuantity();
    expect(cubit.state.quantity, 3);
  });

  test('decrementQuantity decreases quantity down to 1', () async {
    mockRepository.productResult = const Right(tProduct);
    await cubit.loadProductDetails(1, initialProduct: tProduct);

    cubit.incrementQuantity();
    expect(cubit.state.quantity, 2);
    cubit.decrementQuantity();
    expect(cubit.state.quantity, 1);
    // Should not go below 1
    cubit.decrementQuantity();
    expect(cubit.state.quantity, 1);
  });


  test('totalPrice calculates price * quantity', () async {
    mockRepository.productResult = const Right(tProduct);
    await cubit.loadProductDetails(1, initialProduct: tProduct);

    expect(cubit.state.totalPrice, 999.0);
    cubit.incrementQuantity();
    expect(cubit.state.totalPrice, 1998.0);
  });
}
