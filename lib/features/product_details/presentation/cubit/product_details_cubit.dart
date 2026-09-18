import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/domain/entities/product_entity.dart';
import '../../domain/usecases/get_product_by_id_use_case.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductByIdUseCase getProductByIdUseCase;

  ProductDetailsCubit({required this.getProductByIdUseCase})
    : super(const ProductDetailsState());

  Future<void> loadProductDetails(
    int id, {
    ProductEntity? initialProduct,
  }) async {
    if (initialProduct != null) {
      emit(
        state.copyWith(
          status: ProductDetailsStatus.success,
          product: initialProduct,
          quantity: initialProduct.isInStock ? 1 : 0,
          clearErrorMessage: true,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: ProductDetailsStatus.loading,
          clearErrorMessage: true,
        ),
      );
    }

    final result = await getProductByIdUseCase(id);
    if (isClosed) return;

    result.fold(
      (failure) {
        if (state.product == null) {
          emit(
            state.copyWith(
              status: ProductDetailsStatus.failure,
              errorMessage: failure.message,
            ),
          );
        } else {
          emit(state.copyWith(errorMessage: failure.message));
        }
      },
      (product) {
        final reconciledQuantity = state.quantity > product.stockQuantity
            ? (product.isInStock ? product.stockQuantity : 0)
            : (state.quantity == 0 && product.isInStock ? 1 : state.quantity);

        emit(
          state.copyWith(
            status: ProductDetailsStatus.success,
            product: product,
            quantity: reconciledQuantity,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void incrementQuantity() {
    final maxStock = state.product?.stockQuantity ?? 0;
    if (state.quantity < maxStock) {
      emit(state.copyWith(quantity: state.quantity + 1));
    }
  }

  void decrementQuantity() {
    final minQuantity = (state.product?.isInStock ?? false) ? 1 : 0;
    if (state.quantity > minQuantity) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }
}
