import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrderByIdUseCase implements UseCase<OrderEntity, int> {
  final OrdersRepository repository;

  GetOrderByIdUseCase(this.repository);

  @override
  Future<Either<Failure, OrderEntity>> call(int id) {
    return repository.getOrderById(id);
  }
}
