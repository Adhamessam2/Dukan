import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import 'home_state.dart';

/// Cubit managing state for the Home feature
class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;

  HomeCubit({
    required this.getCategoriesUseCase,
    required this.getProductsUseCase,
  }) : super(const HomeState());

  /// Loads both categories and products concurrently
  Future<void> loadHomeData() async {
    emit(
      state.copyWith(
        categoriesStatus: HomeStatus.loading,
        productsStatus: HomeStatus.loading,
      ),
    );

    await Future.wait([_fetchCategories(), _fetchProducts()]);
  }

  Future<void> _fetchCategories() async {
    final result = await getCategoriesUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          categoriesStatus: HomeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        state.copyWith(
          categoriesStatus: HomeStatus.success,
          categories: categories,
        ),
      ),
    );
  }

  Future<void> _fetchProducts() async {
    final result = await getProductsUseCase(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          productsStatus: HomeStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (products) => emit(
        state.copyWith(productsStatus: HomeStatus.success, products: products),
      ),
    );
  }

  /// Sets the active category filter (null means 'All')
  void selectCategory(int? categoryId) {
    emit(state.copyWith(selectedCategoryId: () => categoryId));
  }

  /// Updates the live search filter query
  void updateSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  /// Updates the active product sorting option
  void selectSortOption(ProductSortOption sortOption) {
    emit(state.copyWith(sortOption: sortOption));
  }
}
