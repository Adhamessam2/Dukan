import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class CancelOrderUseCase implements UseCase<OrderEntity, int> {
  final OrdersRepository repository;

  CancelOrderUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(int id) {
    return repository.cancelOrder(id);
  }
}
