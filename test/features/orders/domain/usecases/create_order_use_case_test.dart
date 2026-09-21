import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/features/orders/domain/entities/create_order_params.dart';
import 'package:Dukan/features/orders/domain/entities/order_entity.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:Dukan/features/orders/domain/repositories/orders_repository.dart';
import 'package:Dukan/features/orders/domain/usecases/create_order_use_case.dart';

class FakeOrdersRepository implements OrdersRepository {
  CreateOrderParams? lastParams;
  OrderEntity? response;
  Failure? failure;

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
    CreateOrderParams params,
  ) async {
    lastParams = params;
    if (failure != null) {
      return Left(failure!);
    }
    return Right(response!);
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(int id) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(int id) =>
      throw UnimplementedError();
}

void main() {
  group('CreateOrderParams', () {
    test('auto-generates fresh UUID v4 when not supplied', () {
      final params1 = CreateOrderParams(
        address: const ShippingAddressEntity(
          city: 'Cairo',
          street: 'Tahrir',
          building: '12',
        ),
        paymentMethod: PaymentMethod.cash,
      );
      final params2 = CreateOrderParams(
        address: const ShippingAddressEntity(
          city: 'Cairo',
          street: 'Tahrir',
          building: '12',
        ),
        paymentMethod: PaymentMethod.cash,
      );

      expect(params1.idempotencyKey.isNotEmpty, isTrue);
      expect(params2.idempotencyKey.isNotEmpty, isTrue);
      expect(params1.idempotencyKey, isNot(equals(params2.idempotencyKey)));
    });

    test('preserves explicitly supplied idempotency key', () {
      const explicitKey = 'test-uuid-1234';
      final params = CreateOrderParams(
        address: const ShippingAddressEntity(
          city: 'Cairo',
          street: 'Tahrir',
          building: '12',
        ),
        paymentMethod: PaymentMethod.creditCard,
        idempotencyKey: explicitKey,
      );

      expect(params.idempotencyKey, equals(explicitKey));
    });

    test('supports value equality', () {
      const address = ShippingAddressEntity(
        city: 'Cairo',
        street: 'Tahrir',
        building: '12',
      );
      final params1 = CreateOrderParams(
        address: address,
        paymentMethod: PaymentMethod.cash,
        idempotencyKey: 'fixed-key',
      );
      final params2 = CreateOrderParams(
        address: address,
        paymentMethod: PaymentMethod.cash,
        idempotencyKey: 'fixed-key',
      );

      expect(params1, equals(params2));
    });
  });

  group('CreateOrderUseCase', () {
    test('delegates createOrder call to OrdersRepository', () async {
      final fakeRepo = FakeOrdersRepository();
      final useCase = CreateOrderUseCase(fakeRepo);
      final expectedOrder = OrderEntity(
        id: 1,
        userId: 2,
        shippingCity: 'Cairo',
        shippingStreet: 'Tahrir',
        shippingBuilding: '1',
        orderStatus: 'PENDING',
        totalAmount: 100.0,
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      fakeRepo.response = expectedOrder;

      final params = CreateOrderParams(
        address: const ShippingAddressEntity(
          city: 'Cairo',
          street: 'Tahrir',
          building: '1',
        ),
        paymentMethod: PaymentMethod.cash,
      );

      final result = await useCase(params);

      expect(result, Right(expectedOrder));
      expect(fakeRepo.lastParams, equals(params));
    });

    test('returns Failure when repository returns Left', () async {
      final fakeRepo = FakeOrdersRepository();
      final useCase = CreateOrderUseCase(fakeRepo);
      fakeRepo.failure = const NetworkFailure();

      final params = CreateOrderParams(
        address: const ShippingAddressEntity(
          city: 'Cairo',
          street: 'Tahrir',
          building: '1',
        ),
        paymentMethod: PaymentMethod.cash,
      );

      final result = await useCase(params);

      expect(result, const Left(NetworkFailure()));
    });
  });
}
