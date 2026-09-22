import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/cancel_order_use_case.dart';
import '../../domain/usecases/get_orders_use_case.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
  final CancelOrderUseCase cancelOrderUseCase;

  OrdersCubit({
    required this.getOrdersUseCase,
    required this.cancelOrderUseCase,
  }) : super(const OrdersState());

  Future<void> loadOrders() async {
    emit(state.copyWith(status: OrdersStatus.loading, clearErrorMessage: true));
    final result = await getOrdersUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrdersStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (orders) =>
          emit(state.copyWith(status: OrdersStatus.success, orders: orders)),
    );
  }

  void setFilter(OrdersFilterTab tab) {
    emit(state.copyWith(selectedFilter: tab));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  Future<void> cancelOrder(int orderId) async {
    final result = await cancelOrderUseCase(orderId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updatedOrder) {
        final updatedOrders = state.orders.map((o) {
          return o.id == orderId ? updatedOrder : o;
        }).toList();
        emit(state.copyWith(orders: updatedOrders));
      },
    );
  }
}
