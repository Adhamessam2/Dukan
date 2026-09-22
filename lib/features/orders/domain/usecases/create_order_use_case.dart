import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/create_order_params.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class CreateOrderUseCase implements UseCase<OrderEntity, CreateOrderParams> {
  final OrdersRepository repository;

  CreateOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(CreateOrderParams params) async {
    return await repository.createOrder(params);
  }
}
