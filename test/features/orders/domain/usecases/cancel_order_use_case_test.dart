import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/orders/domain/entities/create_order_params.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/cancel_order_use_case.dart';

class FakeOrdersRepository implements OrdersRepository {
  OrderEntity? orderResponse;
  Failure? failure;
  int? capturedId;

  @override
  Future<Either<Failure, OrderEntity>> createOrder(CreateOrderParams params) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(int id) async {
    capturedId = id;
    if (failure != null) return Left(failure!);
    return Right(orderResponse!);
  }
}

void main() {
  test('CancelOrderUseCase delegates to repository.cancelOrder(id)', () async {
    final fakeRepo = FakeOrdersRepository();
    final useCase = CancelOrderUseCase(fakeRepo);

    final expectedOrder = OrderEntity(
      id: 4,
      shippingCity: 'Cairo',
      shippingStreet: 'Tahrir',
      shippingBuilding: '12',
      orderStatus: 'CANCELLED',
      totalAmount: 136.5,
      paymentMethod: PaymentMethod.cash,
      createdAt: DateTime.now(),
    );
    fakeRepo.orderResponse = expectedOrder;

    final result = await useCase(4);

    expect(result, Right(expectedOrder));
    expect(fakeRepo.capturedId, 4);
  });

  test('CancelOrderUseCase returns Failure on error', () async {
    final fakeRepo = FakeOrdersRepository();
    final useCase = CancelOrderUseCase(fakeRepo);
    fakeRepo.failure = const ServerFailure(message: 'Cannot cancel order');

    final result = await useCase(4);

    expect(result, const Left(ServerFailure(message: 'Cannot cancel order')));
    expect(fakeRepo.capturedId, 4);
  });
}
