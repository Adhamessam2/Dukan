import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_image_entity.dart';
import 'category_model.dart';
import 'product_image_model.dart';

/// Data model representing a product, extending [ProductEntity]
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.productName,
    super.productDescription,
    super.sku,
    super.stockQuantity = 0,
    required super.price,
    super.avgRating = 0.0,
    super.totalReviews = 0,
    super.category,
    super.productImages = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    int stockQuantity = 0;
    if (json['stock'] is Map) {
      stockQuantity =
          ((json['stock'] as Map)['quantity'] as num?)?.toInt() ?? 0;
    } else if (json['stock'] is num) {
      stockQuantity = (json['stock'] as num).toInt();
    }

    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      productName: (json['productName'] as String?)?.trim() ?? '',
      productDescription: json['productDescription'] as String?,
      sku: json['sku'] as String?,
      stockQuantity: stockQuantity,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      avgRating: double.tryParse(json['avgRating']?.toString() ?? '0') ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      category: json['category'] is Map
          ? CategoryModel.fromJson(
              Map<String, dynamic>.from(json['category'] as Map),
            )
          : null,
      productImages: List<ProductImageEntity>.unmodifiable(
        (json['productImages'] as List<dynamic>?)
                ?.whereType<Map>()
                .map(
                  (img) => ProductImageModel.fromJson(
                    Map<String, dynamic>.from(img),
                  ),
                )
                .toList() ??
            const [],
      ),
    );
  }
}
