import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product_entity.dart';

enum ProductDetailsStatus { initial, loading, success, failure }

class ProductDetailsState extends Equatable {
  final ProductDetailsStatus status;
  final ProductEntity? product;
  final int quantity;
  final String? errorMessage;

  const ProductDetailsState({
    this.status = ProductDetailsStatus.initial,
    this.product,
    this.quantity = 1,
    this.errorMessage,
  });

  double get totalPrice {
    final price = product?.price ?? 0.0;
    return price * quantity;
  }

  ProductDetailsState copyWith({
    ProductDetailsStatus? status,
    ProductEntity? product,
    int? quantity,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ProductDetailsState(
      status: status ?? this.status,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, product, quantity, errorMessage];
}
