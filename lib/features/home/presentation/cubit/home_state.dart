import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

enum HomeStatus { initial, loading, success, failure }

/// Available sorting options for products
enum ProductSortOption {
  curated('Curated'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  topRated('Top Rated');

  final String label;

  const ProductSortOption(this.label);
}

/// State representation for Home feature
class HomeState extends Equatable {
  final HomeStatus categoriesStatus;
  final HomeStatus productsStatus;
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final int? selectedCategoryId;
  final String? errorMessage;
  final String searchQuery;
  final ProductSortOption sortOption;

  const HomeState({
    this.categoriesStatus = HomeStatus.initial,
    this.productsStatus = HomeStatus.initial,
    this.categories = const [],
    this.products = const [],
    this.selectedCategoryId,
    this.errorMessage,
    this.searchQuery = '',
    this.sortOption = ProductSortOption.curated,
  });

  /// Computed list of products matching the active category chip and search query,
  /// sorted by the active sort option.
  List<ProductEntity> get filteredProducts {
    final list = products.where((product) {
      final matchesCategory =
          selectedCategoryId == null ||
          product.categoryId == selectedCategoryId ||
          product.category?.id == selectedCategoryId ||
          product.category?.parent?.id == selectedCategoryId ||
          product.category?.parentId == selectedCategoryId;

      final matchesSearch =
          searchQuery.isEmpty ||
          product.productName.toLowerCase().contains(
            searchQuery.toLowerCase(),
          ) ||
          (product.productDescription?.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ) ??
              false);

      return matchesCategory && matchesSearch;
    }).toList();

    switch (sortOption) {
      case ProductSortOption.curated:
        return list;
      case ProductSortOption.priceLowToHigh:
        return list..sort((a, b) => a.price.compareTo(b.price));
      case ProductSortOption.priceHighToLow:
        return list..sort((a, b) => b.price.compareTo(a.price));
      case ProductSortOption.topRated:
        return list..sort((a, b) => b.avgRating.compareTo(a.avgRating));
    }
  }

  HomeState copyWith({
    HomeStatus? categoriesStatus,
    HomeStatus? productsStatus,
    List<CategoryEntity>? categories,
    List<ProductEntity>? products,
    int? Function()? selectedCategoryId,
    String? errorMessage,
    String? searchQuery,
    ProductSortOption? sortOption,
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
      sortOption: sortOption ?? this.sortOption,
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
    sortOption,
  ];
}
