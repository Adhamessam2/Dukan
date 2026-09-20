import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_to_cart_use_case.dart';
import '../../domain/usecases/clear_cart_use_case.dart';
import '../../domain/usecases/delete_cart_item_use_case.dart';
import '../../domain/usecases/get_cart_item_use_case.dart';
import '../../domain/usecases/get_cart_use_case.dart';
import '../../domain/usecases/update_cart_item_use_case.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AddToCartUseCase addToCartUseCase;
  final GetCartUseCase getCartUseCase;
  final GetCartItemUseCase getCartItemUseCase;
  final UpdateCartItemUseCase updateCartItemUseCase;
  final DeleteCartItemUseCase deleteCartItemUseCase;
  final ClearCartUseCase clearCartUseCase;

  CartCubit({
    required this.addToCartUseCase,
    required this.getCartUseCase,
    required this.getCartItemUseCase,
    required this.updateCartItemUseCase,
    required this.deleteCartItemUseCase,
    required this.clearCartUseCase,
  }) : super(const CartState());

  Future<void> addToCart({
    required int productId,
    required int quantity,
  }) async {
    emit(
      state.copyWith(
        status: CartStatus.loading,
        addingProductId: productId,
        clearErrorMessage: true,
      ),
    );

    final result = await addToCartUseCase(
      AddToCartParams(productId: productId, quantity: quantity),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CartStatus.failure,
          clearAddingProductId: true,
          errorMessage: failure.message,
        ),
      ),
      (item) => emit(
        state.copyWith(
          status: CartStatus.success,
          clearAddingProductId: true,
          lastAddedItem: item,
        ),
      ),
    );
  }

  Future<void> getCart() async {
    emit(
      state.copyWith(
        getCartStatus: CartStatus.loading,
        clearGetCartErrorMessage: true,
      ),
    );

    final result = await getCartUseCase(const NoParams());

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          getCartStatus: CartStatus.failure,
          getCartErrorMessage: failure.message,
        ),
      ),
      (cart) =>
          emit(state.copyWith(getCartStatus: CartStatus.success, cart: cart)),
    );
  }

  Future<void> getCartItem({
    required String cartId,
    required String productId,
  }) async {
    emit(
      state.copyWith(
        getCartItemStatus: CartStatus.loading,
        clearGetCartItemErrorMessage: true,
      ),
    );

    final result = await getCartItemUseCase(
      GetCartItemParams(cartId: cartId, productId: productId),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          getCartItemStatus: CartStatus.failure,
          getCartItemErrorMessage: failure.message,
        ),
      ),
      (product) => emit(
        state.copyWith(
          getCartItemStatus: CartStatus.success,
          cartItemProduct: product,
        ),
      ),
    );
  }

  Future<void> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    emit(
      state.copyWith(
        updateCartItemStatus: CartStatus.loading,
        clearUpdateCartItemErrorMessage: true,
      ),
    );

    final result = await updateCartItemUseCase(
      UpdateCartItemParams(
        cartId: cartId,
        productId: productId,
        quantity: quantity,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          updateCartItemStatus: CartStatus.failure,
          updateCartItemErrorMessage: failure.message,
        ),
      ),
      (item) => emit(
        state.copyWith(
          updateCartItemStatus: CartStatus.success,
          updatedCartItem: item,
        ),
      ),
    );
  }

  Future<void> deleteCartItem({
    required String cartId,
    required String productId,
  }) async {
    emit(
      state.copyWith(
        deleteCartItemStatus: CartStatus.loading,
        clearDeleteCartItemErrorMessage: true,
      ),
    );

    final result = await deleteCartItemUseCase(
      DeleteCartItemParams(cartId: cartId, productId: productId),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteCartItemStatus: CartStatus.failure,
          deleteCartItemErrorMessage: failure.message,
        ),
      ),
      (item) => emit(
        state.copyWith(
          deleteCartItemStatus: CartStatus.success,
          deletedCartItem: item,
        ),
      ),
    );
  }

  Future<void> clearCart() async {
    emit(
      state.copyWith(
        clearCartStatus: CartStatus.loading,
        clearClearCartErrorMessage: true,
      ),
    );

    final result = await clearCartUseCase(const NoParams());

    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          clearCartStatus: CartStatus.failure,
          clearCartErrorMessage: failure.message,
        ),
      ),
      (count) => emit(
        state.copyWith(
          clearCartStatus: CartStatus.success,
          clearedItemCount: count,
        ),
      ),
    );
  }
}
