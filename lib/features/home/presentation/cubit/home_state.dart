import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

enum HomeStatus { initial, loading, success, failure }

/// State representation for Home feature
class HomeState extends Equatable {
  final HomeStatus categoriesStatus;
  final HomeStatus productsStatus;
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final int? selectedCategoryId;
  final String? errorMessage;
  final String searchQuery;

  const HomeState({
    this.categoriesStatus = HomeStatus.initial,
    this.productsStatus = HomeStatus.initial,
    this.categories = const [],
    this.products = const [],
    this.selectedCategoryId,
    this.errorMessage,
    this.searchQuery = '',
  });

  /// Computed list of products matching the active category chip and search query
  List<ProductEntity> get filteredProducts {
    return products.where((product) {
      final matchesCategory = selectedCategoryId == null ||
          product.category?.id == selectedCategoryId ||
          product.category?.parent?.id == selectedCategoryId ||
          product.category?.parentId == selectedCategoryId;

      final matchesSearch = searchQuery.isEmpty ||
          product.productName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (product.productDescription
                  ?.toLowerCase()
                  .contains(searchQuery.toLowerCase()) ??
              false);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  HomeState copyWith({
    HomeStatus? categoriesStatus,
    HomeStatus? productsStatus,
    List<CategoryEntity>? categories,
    List<ProductEntity>? products,
    int? Function()? selectedCategoryId,
    String? errorMessage,
    String? searchQuery,
  }) {
    return HomeState(
      categoriesStatus: categoriesStatus ?? this.categoriesStatus,
      productsStatus: productsStatus ?? this.productsStatus,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId != null
          ? selectedCategoryId()
          : this.selectedCategoryId,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        categoriesStatus,
        productsStatus,
        categories,
        products,
        selectedCategoryId,
        errorMessage,
        searchQuery,
      ];
}
