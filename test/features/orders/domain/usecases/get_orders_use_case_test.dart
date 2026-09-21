import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/usecases/usecase.dart';
import 'package:Dukan/features/orders/domain/entities/create_order_params.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_payment_status_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/get_orders_use_case.dart';

class FakeOrdersRepository implements OrdersRepository {
  List<OrderEntity>? ordersResponse;
  Failure? failure;

  @override
  Future<Either<Failure, OrderEntity>> createOrder(CreateOrderParams params) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    if (failure != null) return Left(failure!);
    return Right(ordersResponse!);
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, OrderPaymentStatusEntity>> getOrderPaymentStatus(
    int id,
  ) => throw UnimplementedError();
}

void main() {
  test('GetOrdersUseCase delegates to repository.getOrders()', () async {
    final fakeRepo = FakeOrdersRepository();
    final useCase = GetOrdersUseCase(fakeRepo);

    final expectedOrders = [
      OrderEntity(
        id: 1,
        shippingCity: 'Cairo',
        shippingStreet: 'Tahrir',
        shippingBuilding: '1',
        orderStatus: 'PENDING',
        totalAmount: 120.0,
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now(),
      ),
    ];
    fakeRepo.ordersResponse = expectedOrders;

    final result = await useCase(const NoParams());

    expect(result, Right(expectedOrders));
  });

  test('GetOrdersUseCase returns Failure on error', () async {
    final fakeRepo = FakeOrdersRepository();
    final useCase = GetOrdersUseCase(fakeRepo);
    fakeRepo.failure = const ServerFailure(message: 'Failed to fetch');

    final result = await useCase(const NoParams());

    expect(result, const Left(ServerFailure(message: 'Failed to fetch')));
  });
}
