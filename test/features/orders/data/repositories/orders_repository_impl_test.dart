import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:Dukan/core/errors/exceptions.dart';
import 'package:Dukan/core/errors/failure.dart';
import 'package:Dukan/core/network/network_info.dart';
import 'package:Dukan/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:Dukan/features/orders/data/models/order_model.dart';
import 'package:Dukan/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:Dukan/features/orders/domain/entities/create_order_params.dart';
import 'package:Dukan/features/orders/domain/entities/payment_method.dart';
import 'package:Dukan/features/orders/domain/entities/shipping_address_entity.dart';

class FakeNetworkInfo implements NetworkInfo {
  bool isOnline = true;
  @override
  Future<bool> get isConnected async => isOnline;
  @override
  Stream<InternetStatus> get onStatusChange => const Stream.empty();
}

class FakeOrdersRemoteDataSource implements OrdersRemoteDataSource {
  OrderModel? modelToReturn;
  List<OrderModel>? ordersToReturn;
  Exception? exceptionToThrow;

  @override
  Future<OrderModel> createOrder(CreateOrderParams params) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return modelToReturn!;
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return ordersToReturn!;
  }

  @override
  Future<OrderModel> getOrderById(int id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return modelToReturn!;
  }

  @override
  Future<OrderModel> cancelOrder(int id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return modelToReturn!;
  }
}

void main() {
  late OrdersRepositoryImpl repository;
  late FakeOrdersRemoteDataSource fakeDataSource;
  late FakeNetworkInfo fakeNetworkInfo;

  setUp(() {
    fakeDataSource = FakeOrdersRemoteDataSource();
    fakeNetworkInfo = FakeNetworkInfo();
    repository = OrdersRepositoryImpl(
      remoteDataSource: fakeDataSource,
      networkInfo: fakeNetworkInfo,
    );
  });

  final params = CreateOrderParams(
    address: const ShippingAddressEntity(
      city: 'Cairo',
      street: 'Tahrir',
      building: '12',
    ),
    paymentMethod: PaymentMethod.cash,
  );

  test('returns Left(NetworkFailure) when offline', () async {
    fakeNetworkInfo.isOnline = false;

    final result = await repository.createOrder(params);

    expect(result, const Left(NetworkFailure()));
  });

  test('returns Right(OrderModel) on remote success', () async {
    fakeNetworkInfo.isOnline = true;
    final orderModel = OrderModel(
      id: 1,
      userId: 1,
      shippingCity: 'Cairo',
      shippingStreet: 'Tahrir',
      shippingBuilding: '12',
      orderStatus: 'PENDING',
      totalAmount: 100.0,
      paymentMethod: PaymentMethod.cash,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    fakeDataSource.modelToReturn = orderModel;

    final result = await repository.createOrder(params);

    expect(result, Right(orderModel));
  });

  test('returns Left(ServerFailure) when ServerException thrown', () async {
    fakeNetworkInfo.isOnline = true;
    fakeDataSource.exceptionToThrow = ServerException(message: 'Server Error');

    final result = await repository.createOrder(params);

    expect(result.isLeft(), isTrue);
    result.fold(
      (failure) => expect(failure, isA<ServerFailure>()),
      (_) => fail('Expected Left'),
    );
  });

  group('getOrders', () {
    test('returns Left(NetworkFailure) when offline', () async {
      fakeNetworkInfo.isOnline = false;

      final result = await repository.getOrders();

      expect(result, const Left(NetworkFailure()));
    });

    test('returns Right(List<OrderModel>) when online', () async {
      fakeNetworkInfo.isOnline = true;
      fakeDataSource.ordersToReturn = [
        OrderModel(
          id: 1,
          shippingCity: 'Cairo',
          shippingStreet: 'Tahrir',
          shippingBuilding: '12',
          orderStatus: 'PENDING',
          totalAmount: 100.0,
          paymentMethod: PaymentMethod.cash,
          createdAt: DateTime.now(),
        ),
      ];

      final result = await repository.getOrders();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (orders) => expect(orders.length, 1),
      );
    });

    test('returns Left(ServerFailure) when ServerException thrown', () async {
      fakeNetworkInfo.isOnline = true;
      fakeDataSource.exceptionToThrow = ServerException(message: 'Error');

      final result = await repository.getOrders();

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('getOrderById', () {
    test('returns Left(NetworkFailure) when offline', () async {
      fakeNetworkInfo.isOnline = false;

      final result = await repository.getOrderById(4);

      expect(result, const Left(NetworkFailure()));
    });

    test('returns Right(OrderModel) on success', () async {
      fakeNetworkInfo.isOnline = true;
      final expected = OrderModel(
        id: 4,
        shippingCity: 'Cairo',
        shippingStreet: 'Tahrir',
        shippingBuilding: '12',
        orderStatus: 'PENDING',
        totalAmount: 136.5,
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now(),
      );
      fakeDataSource.modelToReturn = expected;

      final result = await repository.getOrderById(4);

      expect(result, Right(expected));
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      fakeNetworkInfo.isOnline = true;
      fakeDataSource.exceptionToThrow = ServerException(
        message: 'Order not found',
      );

      final result = await repository.getOrderById(4);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('cancelOrder', () {
    test('returns Left(NetworkFailure) when offline', () async {
      fakeNetworkInfo.isOnline = false;

      final result = await repository.cancelOrder(4);

      expect(result, const Left(NetworkFailure()));
    });

    test('returns Right(OrderModel) on success', () async {
      fakeNetworkInfo.isOnline = true;
      final expected = OrderModel(
        id: 4,
        shippingCity: 'Cairo',
        shippingStreet: 'Tahrir',
        shippingBuilding: '12',
        orderStatus: 'CANCELLED',
        totalAmount: 136.5,
        paymentMethod: PaymentMethod.cash,
        createdAt: DateTime.now(),
        updatedAt: DateTime.parse('2026-09-21T14:44:26.776Z'),
      );
      fakeDataSource.modelToReturn = expected;

      final result = await repository.cancelOrder(4);

      expect(result, Right(expected));
      result.fold(
        (_) => fail('Expected Right'),
        (order) => expect(order.orderStatus, 'CANCELLED'),
      );
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      fakeNetworkInfo.isOnline = true;
      fakeDataSource.exceptionToThrow = ServerException(
        message: 'Order cannot be cancelled',
      );

      final result = await repository.cancelOrder(4);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
