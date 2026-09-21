import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/create_order_params.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_payment_status_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OrderEntity>> createOrder(
    CreateOrderParams params,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final order = await remoteDataSource.createOrder(params);
      return Right(order);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final orders = await remoteDataSource.getOrders();
      return Right(orders);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderById(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final order = await remoteDataSource.getOrderById(id);
      return Right(order);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(int id) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final order = await remoteDataSource.cancelOrder(id);
      return Right(order);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, OrderPaymentStatusEntity>> getOrderPaymentStatus(
    int id,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final status = await remoteDataSource.getOrderPaymentStatus(id);
      return Right(status);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
