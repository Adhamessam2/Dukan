import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/create_order_params.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../../domain/usecases/create_order_use_case.dart';
import 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CreateOrderUseCase createOrderUseCase;

  CheckoutCubit({required this.createOrderUseCase})
    : super(const CheckoutState());

  void selectPaymentMethod(PaymentMethod method) {
    emit(state.copyWith(selectedPaymentMethod: method));
  }

  Future<void> submitOrder({
    required String city,
    required String street,
    required String building,
  }) async {
    if (state.status == CheckoutStatus.submitting) return;

    emit(
      state.copyWith(
        status: CheckoutStatus.submitting,
        clearErrorMessage: true,
      ),
    );

    final params = CreateOrderParams(
      address: ShippingAddressEntity(
        city: city.trim(),
        street: street.trim(),
        building: building.trim(),
      ),
      paymentMethod: state.selectedPaymentMethod,
    );

    final result = await createOrderUseCase(params);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (order) => emit(
        state.copyWith(status: CheckoutStatus.success, createdOrder: order),
      ),
    );
  }
}
