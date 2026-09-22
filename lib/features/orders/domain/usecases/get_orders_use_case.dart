import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrdersUseCase implements UseCase<List<OrderEntity>, NoParams> {
  final OrdersRepository repository;

  GetOrdersUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(NoParams params) async {
    return await repository.getOrders();
  }
}
