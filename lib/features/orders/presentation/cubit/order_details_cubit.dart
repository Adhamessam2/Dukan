import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_payment_status_entity.dart';
import '../../domain/usecases/cancel_order_use_case.dart';
import '../../domain/usecases/get_order_by_id_use_case.dart';
import '../../domain/usecases/get_order_payment_status_use_case.dart';
import 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final GetOrderByIdUseCase getOrderByIdUseCase;
  final GetOrderPaymentStatusUseCase getOrderPaymentStatusUseCase;
  final CancelOrderUseCase cancelOrderUseCase;

  OrderDetailsCubit({
    required this.getOrderByIdUseCase,
    required this.getOrderPaymentStatusUseCase,
    required this.cancelOrderUseCase,
  }) : super(const OrderDetailsState());

  Future<void> loadOrderDetails(int orderId) async {
    emit(
      state.copyWith(
        status: OrderDetailsStatus.loading,
        clearErrorMessage: true,
      ),
    );

    final results = await Future.wait([
      getOrderByIdUseCase(orderId),
      getOrderPaymentStatusUseCase(orderId),
    ]);

    if (isClosed) return;

    final orderResult = results[0];
    final paymentResult = results[1];

    orderResult.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderDetailsStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (order) {
        final OrderPaymentStatusEntity? paymentStatus = paymentResult.fold(
          (_) => null,
          (payment) => payment as OrderPaymentStatusEntity,
        );

        emit(
          state.copyWith(
            status: OrderDetailsStatus.success,
            order: order as OrderEntity,
            paymentStatus: paymentStatus,
          ),
        );
      },
    );
  }

  Future<void> reorderAllItems(CartCubit cartCubit) async {
    final order = state.order;
    if (order == null || order.items.isEmpty) return;

    emit(state.copyWith(isReordering: true));

    for (final item in order.items) {
      if (isClosed) return;
      await cartCubit.addToCart(
        productId: item.product.id,
        quantity: item.quantity,
      );
    }

    if (isClosed) return;

    emit(state.copyWith(isReordering: false));
  }

  Future<bool> cancelOrder(int orderId) async {
    emit(state.copyWith(isCancelling: true, clearErrorMessage: true));
    final result = await cancelOrderUseCase(orderId);
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isCancelling: false,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (cancelledOrder) {
        emit(
          state.copyWith(
            isCancelling: false,
            order: cancelledOrder,
          ),
        );
        return true;
      },
    );
  }
}
