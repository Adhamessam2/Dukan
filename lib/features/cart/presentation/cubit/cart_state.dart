import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final int? addingProductId;
  final CartItemEntity? lastAddedItem;
  final String? errorMessage;

  final CartStatus getCartStatus;
  final CartEntity? cart;
  final String? getCartErrorMessage;

  final CartStatus getCartItemStatus;
  final ProductEntity? cartItemProduct;
  final String? getCartItemErrorMessage;

  final CartStatus updateCartItemStatus;
  final CartItemEntity? updatedCartItem;
  final String? updateCartItemErrorMessage;

  final CartStatus deleteCartItemStatus;
  final CartItemEntity? deletedCartItem;
  final String? deleteCartItemErrorMessage;

  final CartStatus clearCartStatus;
  final int? clearedItemCount;
  final String? clearCartErrorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.addingProductId,
    this.lastAddedItem,
    this.errorMessage,
    this.getCartStatus = CartStatus.initial,
    this.cart,
    this.getCartErrorMessage,
    this.getCartItemStatus = CartStatus.initial,
    this.cartItemProduct,
    this.getCartItemErrorMessage,
    this.updateCartItemStatus = CartStatus.initial,
    this.updatedCartItem,
    this.updateCartItemErrorMessage,
    this.deleteCartItemStatus = CartStatus.initial,
    this.deletedCartItem,
    this.deleteCartItemErrorMessage,
    this.clearCartStatus = CartStatus.initial,
    this.clearedItemCount,
    this.clearCartErrorMessage,
  });

  CartState copyWith({
    CartStatus? status,
    int? addingProductId,
    CartItemEntity? lastAddedItem,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearAddingProductId = false,
    CartStatus? getCartStatus,
    CartEntity? cart,
    String? getCartErrorMessage,
    bool clearGetCartErrorMessage = false,
    CartStatus? getCartItemStatus,
    ProductEntity? cartItemProduct,
    String? getCartItemErrorMessage,
    bool clearGetCartItemErrorMessage = false,
    bool clearCartItemProduct = false,
    CartStatus? updateCartItemStatus,
    CartItemEntity? updatedCartItem,
    String? updateCartItemErrorMessage,
    bool clearUpdateCartItemErrorMessage = false,
    bool clearUpdatedCartItem = false,
    CartStatus? deleteCartItemStatus,
    CartItemEntity? deletedCartItem,
    String? deleteCartItemErrorMessage,
    bool clearDeleteCartItemErrorMessage = false,
    bool clearDeletedCartItem = false,
    CartStatus? clearCartStatus,
    int? clearedItemCount,
    String? clearCartErrorMessage,
    bool clearClearCartErrorMessage = false,
    bool clearClearedItemCount = false,
  }) {
    return CartState(
      status: status ?? this.status,
      addingProductId: clearAddingProductId
          ? null
          : (addingProductId ?? this.addingProductId),
      lastAddedItem: lastAddedItem ?? this.lastAddedItem,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      getCartStatus: getCartStatus ?? this.getCartStatus,
      cart: cart ?? this.cart,
      getCartErrorMessage: clearGetCartErrorMessage
          ? null
          : (getCartErrorMessage ?? this.getCartErrorMessage),
      getCartItemStatus: getCartItemStatus ?? this.getCartItemStatus,
      cartItemProduct: clearCartItemProduct
          ? null
          : (cartItemProduct ?? this.cartItemProduct),
      getCartItemErrorMessage: clearGetCartItemErrorMessage
          ? null
          : (getCartItemErrorMessage ?? this.getCartItemErrorMessage),
      updateCartItemStatus: updateCartItemStatus ?? this.updateCartItemStatus,
      updatedCartItem: clearUpdatedCartItem
          ? null
          : (updatedCartItem ?? this.updatedCartItem),
      updateCartItemErrorMessage: clearUpdateCartItemErrorMessage
          ? null
          : (updateCartItemErrorMessage ?? this.updateCartItemErrorMessage),
      deleteCartItemStatus: deleteCartItemStatus ?? this.deleteCartItemStatus,
      deletedCartItem: clearDeletedCartItem
          ? null
          : (deletedCartItem ?? this.deletedCartItem),
      deleteCartItemErrorMessage: clearDeleteCartItemErrorMessage
          ? null
          : (deleteCartItemErrorMessage ?? this.deleteCartItemErrorMessage),
      clearCartStatus: clearCartStatus ?? this.clearCartStatus,
      clearedItemCount: clearClearedItemCount
          ? null
          : (clearedItemCount ?? this.clearedItemCount),
      clearCartErrorMessage: clearClearCartErrorMessage
          ? null
          : (clearCartErrorMessage ?? this.clearCartErrorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    addingProductId,
    lastAddedItem,
    errorMessage,
    getCartStatus,
    cart,
    getCartErrorMessage,
    getCartItemStatus,
    cartItemProduct,
    getCartItemErrorMessage,
    updateCartItemStatus,
    updatedCartItem,
    updateCartItemErrorMessage,
    deleteCartItemStatus,
    deletedCartItem,
    deleteCartItemErrorMessage,
    clearCartStatus,
    clearedItemCount,
    clearCartErrorMessage,
  ];
}
