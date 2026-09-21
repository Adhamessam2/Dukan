import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_payment_status_entity.dart';
import '../repositories/orders_repository.dart';

class GetOrderPaymentStatusUseCase
    implements UseCase<OrderPaymentStatusEntity, int> {
  final OrdersRepository repository;

  GetOrderPaymentStatusUseCase(this.repository);

  @override
  Future<Either<Failure, OrderPaymentStatusEntity>> call(int id) {
    return repository.getOrderPaymentStatus(id);
  }
}
