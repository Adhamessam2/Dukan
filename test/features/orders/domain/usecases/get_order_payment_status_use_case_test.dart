import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/orders/domain/entities/create_order_params.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/order_payment_status_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_transaction_entity.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/get_order_payment_status_use_case.dart';

class FakeOrdersRepository implements OrdersRepository {
  OrderPaymentStatusEntity? paymentStatusResponse;
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
  Future<Either<Failure, OrderEntity>> cancelOrder(int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, OrderPaymentStatusEntity>> getOrderPaymentStatus(
    int id,
  ) async {
    capturedId = id;
    if (failure != null) return Left(failure!);
    return Right(paymentStatusResponse!);
  }
}

void main() {
  final tStatus = OrderPaymentStatusEntity(
    id: 5,
    orderStatus: 'PENDING',
    totalAmount: 0.5,
    payments: [
      PaymentTransactionEntity(
        id: 'cmu9z81di00005mohki9g8mgy',
        status: 'PENDING',
        provider: 'PAYMOB',
        updatedAt: DateTime.parse('2026-09-20T15:34:00.421Z'),
      ),
    ],
  );

  test(
    'GetOrderPaymentStatusUseCase delegates to repository.getOrderPaymentStatus(id)',
    () async {
      final fakeRepo = FakeOrdersRepository();
      final useCase = GetOrderPaymentStatusUseCase(fakeRepo);
      fakeRepo.paymentStatusResponse = tStatus;

      final result = await useCase(5);

      expect(result, Right(tStatus));
      expect(fakeRepo.capturedId, 5);
    },
  );

  test('GetOrderPaymentStatusUseCase returns Failure on error', () async {
    final fakeRepo = FakeOrdersRepository();
    final useCase = GetOrderPaymentStatusUseCase(fakeRepo);
    fakeRepo.failure = const ServerFailure(message: 'Payment not found');

    final result = await useCase(999);

    expect(result, const Left(ServerFailure(message: 'Payment not found')));
    expect(fakeRepo.capturedId, 999);
  });
}
