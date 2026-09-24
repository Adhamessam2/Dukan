import '../../../../core/api/api_keys.dart';
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
    if (json[ApiKeys.stock] is Map) {
      stockQuantity =
          ((json[ApiKeys.stock] as Map)[ApiKeys.stockQuantity] as num?)?.toInt() ?? 0;
    } else if (json[ApiKeys.stock] is num) {
      stockQuantity = (json[ApiKeys.stock] as num).toInt();
    }

    return ProductModel(
      id: (json[ApiKeys.id] as num?)?.toInt() ?? 0,
      productName: (json[ApiKeys.productName] as String?)?.trim() ?? '',
      productDescription: json[ApiKeys.productDescription] as String?,
      sku: json[ApiKeys.sku] as String?,
      stockQuantity: stockQuantity,
      price: double.tryParse(json[ApiKeys.price]?.toString() ?? '0') ?? 0.0,
      avgRating: double.tryParse(json[ApiKeys.avgRating]?.toString() ?? '0') ?? 0.0,
      totalReviews: (json[ApiKeys.totalReviews] as num?)?.toInt() ?? 0,
      category: json[ApiKeys.category] is Map
          ? CategoryModel.fromJson(
              Map<String, dynamic>.from(json[ApiKeys.category] as Map),
            )
          : null,
      productImages: List<ProductImageEntity>.unmodifiable(
        (json[ApiKeys.productImages] as List<dynamic>?)
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
