import 'package:equatable/equatable.dart';
import 'category_entity.dart';
import 'product_image_entity.dart';

/// Domain entity representing a product
class ProductEntity extends Equatable {
  final int id;
  final String productName;
  final String? productDescription;
  final String? sku;
  final int stockQuantity;
  final double price;
  final double avgRating;
  final int totalReviews;
  final CategoryEntity? category;
  final List<ProductImageEntity> productImages;

  const ProductEntity({
    required this.id,
    required this.productName,
    this.productDescription,
    this.sku,
    this.stockQuantity = 0,
    required this.price,
    this.avgRating = 0.0,
    this.totalReviews = 0,
    this.category,
    this.productImages = const [],
  });

  @override
  List<Object?> get props => [
    id,
    productName,
    productDescription,
    sku,
    stockQuantity,
    price,
    avgRating,
    totalReviews,
    category,
    productImages,
  ];

  /// Returns the designated primary image, or the first available image
  ProductImageEntity? get primaryImage {
    for (final img in productImages) {
      if (img.isPrimary) return img;
    }
    return productImages.firstOrNull;
  }

  /// Returns the URL string of the primary image, if present
  String? get primaryImageUrl => primaryImage?.url;
}
