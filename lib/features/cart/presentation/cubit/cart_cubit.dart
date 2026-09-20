import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
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
    final pId = int.tryParse(productId) ?? 0;
    final previousCart = state.cart;

    // Optimistically update cart in state through cubit for instant feedback
    CartEntity? optimisticCart = state.cart;
    if (state.cart != null) {
      final updatedItems = state.cart!.items.map((it) {
        if (it.productId == pId) {
          return CartItemEntity(
            cartId: it.cartId,
            productId: it.productId,
            quantity: quantity,
            isDeleted: it.isDeleted,
            product: it.product,
          );
        }
        return it;
      }).toList();

      final newTotal = updatedItems.fold<double>(
        0.0,
        (sum, it) => sum + ((it.product?.price ?? 0.0) * it.quantity),
      );

      optimisticCart = CartEntity(
        id: state.cart!.id,
        items: updatedItems,
        totalPrice: double.parse(newTotal.toStringAsFixed(2)),
      );
    }

    emit(
      state.copyWith(
        updateCartItemStatus: CartStatus.loading,
        cart: optimisticCart,
        pendingProductIds: {...state.pendingProductIds, pId},
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
          cart: previousCart,
          pendingProductIds: state.pendingProductIds
              .where((id) => id != pId)
              .toSet(),
          updateCartItemErrorMessage: failure.message,
        ),
      ),
      (item) {
        CartEntity? reconciledCart = state.cart;
        if (state.cart != null) {
          final items = state.cart!.items.map((it) {
            if (it.productId == pId) {
              return CartItemEntity(
                cartId: item.cartId ?? it.cartId,
                productId: it.productId,
                quantity: item.quantity,
                isDeleted: item.isDeleted,
                product: it.product,
              );
            }
            return it;
          }).toList();

          final total = items.fold<double>(
            0.0,
            (sum, it) => sum + ((it.product?.price ?? 0.0) * it.quantity),
          );

          reconciledCart = CartEntity(
            id: state.cart!.id,
            items: items,
            totalPrice: double.parse(total.toStringAsFixed(2)),
          );
        }

        emit(
          state.copyWith(
            updateCartItemStatus: CartStatus.success,
            updatedCartItem: item,
            cart: reconciledCart,
            pendingProductIds: state.pendingProductIds
                .where((id) => id != pId)
                .toSet(),
          ),
        );
      },
    );
  }

  Future<void> deleteCartItem({
    required String cartId,
    required String productId,
  }) async {
    final pId = int.tryParse(productId) ?? 0;
    emit(
      state.copyWith(
        deleteCartItemStatus: CartStatus.loading,
        pendingProductIds: {...state.pendingProductIds, pId},
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
          pendingProductIds: state.pendingProductIds
              .where((id) => id != pId)
              .toSet(),
          deleteCartItemErrorMessage: failure.message,
        ),
      ),
      (item) {
        CartEntity? updatedCart = state.cart;
        if (state.cart != null) {
          List<CartItemEntity> updatedItems;
          if (item.isDeleted) {
            updatedItems = state.cart!.items
                .where((it) => it.productId != pId)
                .toList();
          } else {
            updatedItems = state.cart!.items.map((it) {
              if (it.productId == pId) {
                return CartItemEntity(
                  cartId: item.cartId ?? it.cartId,
                  productId: it.productId,
                  quantity: item.quantity,
                  isDeleted: item.isDeleted,
                  product: it.product,
                );
              }
              return it;
            }).toList();
          }

          final newTotal = updatedItems.fold<double>(
            0.0,
            (sum, it) => sum + ((it.product?.price ?? 0.0) * it.quantity),
          );

          updatedCart = CartEntity(
            id: state.cart!.id,
            items: updatedItems,
            totalPrice: double.parse(newTotal.toStringAsFixed(2)),
          );
        }

        emit(
          state.copyWith(
            deleteCartItemStatus: CartStatus.success,
            deletedCartItem: item,
            cart: updatedCart,
            pendingProductIds: state.pendingProductIds
                .where((id) => id != pId)
                .toSet(),
          ),
        );
      },
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
      (count) {
        CartEntity? clearedCart;
        if (state.cart != null) {
          clearedCart = CartEntity(
            id: state.cart!.id,
            items: const [],
            totalPrice: 0.0,
          );
        }

        emit(
          state.copyWith(
            clearCartStatus: CartStatus.success,
            clearedItemCount: count,
            cart: clearedCart,
          ),
        );
      },
    );
  }
}
