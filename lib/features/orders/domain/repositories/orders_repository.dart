import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/create_order_params.dart';
import '../entities/order_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, OrderEntity>> createOrder(CreateOrderParams params);
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderEntity>> getOrderById(int id);
  Future<Either<Failure, OrderEntity>> cancelOrder(int id);
}
