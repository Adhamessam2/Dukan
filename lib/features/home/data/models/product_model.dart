import '../../../../core/api/api_keys.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_image_entity.dart';
import 'category_model.dart';
import 'product_image_model.dart';

/// Data model representing a product, extending [ProductEntity]
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    super.categoryId,
    required super.productName,
    super.productDescription,
    super.sku,
    super.stockQuantity = 0,
    required super.price,
    super.avgRating = 0.0,
    super.totalReviews = 0,
    super.category,
    super.productImages = const [],
    super.isDeleted = false,
    super.createdAt,
    super.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final parsedId =
        (json[ApiKeys.id] as num?)?.toInt() ??
        int.tryParse(json[ApiKeys.id]?.toString() ?? '0') ??
        0;

    final isDeleted =
        json[ApiKeys.isDeleted] is bool
            ? json[ApiKeys.isDeleted] as bool
            : json[ApiKeys.isDeleted]?.toString().toLowerCase() == 'true';

    int stockQuantity = 0;
    if (json[ApiKeys.stock] is Map) {
      stockQuantity =
          ((json[ApiKeys.stock] as Map)[ApiKeys.stockQuantity] as num?)
              ?.toInt() ??
          0;
    } else if (json[ApiKeys.stock] is num) {
      stockQuantity = (json[ApiKeys.stock] as num).toInt();
    } else if (json[ApiKeys.stockQuantity] is num) {
      stockQuantity = (json[ApiKeys.stockQuantity] as num).toInt();
    } else {
      // If stock is not specified in the response:
      // Active (non-deleted) products default to available stock (1)
      stockQuantity = isDeleted ? 0 : 1;
    }

    final categoryId =
        (json[ApiKeys.categoryId] as num?)?.toInt() ??
        int.tryParse(json[ApiKeys.categoryId]?.toString() ?? '') ??
        (json[ApiKeys.category] is Map
            ? ((json[ApiKeys.category] as Map)[ApiKeys.id] as num?)?.toInt()
            : null);

    final createdAtRaw = json[ApiKeys.createdAt]?.toString();
    final createdAt =
        createdAtRaw != null ? DateTime.tryParse(createdAtRaw) : null;

    final updatedAtRaw = json[ApiKeys.updatedAt]?.toString();
    final updatedAt =
        updatedAtRaw != null ? DateTime.tryParse(updatedAtRaw) : null;

    final rawImages = json[ApiKeys.productImages];
    final List<ProductImageEntity> parsedImages = [];
    if (rawImages is List) {
      for (int i = 0; i < rawImages.length; i++) {
        final item = rawImages[i];
        if (item is Map) {
          parsedImages.add(
            ProductImageModel.fromJson(
              Map<String, dynamic>.from(item),
              defaultProductId: parsedId,
              defaultIsPrimary: i == 0,
            ),
          );
        } else if (item is String && item.trim().isNotEmpty) {
          parsedImages.add(
            ProductImageModel(
              id: '${parsedId}_img_$i',
              productId: parsedId,
              url: item.trim(),
              isPrimary: i == 0,
            ),
          );
        }
      }
    } else if (json['image'] is String &&
        (json['image'] as String).trim().isNotEmpty) {
      parsedImages.add(
        ProductImageModel(
          id: '${parsedId}_img_0',
          productId: parsedId,
          url: (json['image'] as String).trim(),
          isPrimary: true,
        ),
      );
    } else if (json['imageUrl'] is String &&
        (json['imageUrl'] as String).trim().isNotEmpty) {
      parsedImages.add(
        ProductImageModel(
          id: '${parsedId}_img_0',
          productId: parsedId,
          url: (json['imageUrl'] as String).trim(),
          isPrimary: true,
        ),
      );
    }

    return ProductModel(
      id: parsedId,
      categoryId: categoryId,
      productName: (json[ApiKeys.productName] as String?)?.trim() ?? '',
      productDescription: json[ApiKeys.productDescription] as String?,
      sku: json[ApiKeys.sku] as String?,
      stockQuantity: stockQuantity,
      price: double.tryParse(json[ApiKeys.price]?.toString() ?? '0') ?? 0.0,
      avgRating:
          double.tryParse(json[ApiKeys.avgRating]?.toString() ?? '0') ?? 0.0,
      totalReviews:
          (json[ApiKeys.totalReviews] as num?)?.toInt() ??
          int.tryParse(json[ApiKeys.totalReviews]?.toString() ?? '0') ??
          0,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      category:
          json[ApiKeys.category] is Map
              ? CategoryModel.fromJson(
                Map<String, dynamic>.from(json[ApiKeys.category] as Map),
              )
              : null,
      productImages: List<ProductImageEntity>.unmodifiable(parsedImages),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.id: id,
      if (categoryId != null) ApiKeys.categoryId: categoryId,
      ApiKeys.productName: productName,
      ApiKeys.productDescription: productDescription,
      if (sku != null) ApiKeys.sku: sku,
      ApiKeys.stock: {ApiKeys.stockQuantity: stockQuantity},
      ApiKeys.price: price.toString(),
      ApiKeys.avgRating: avgRating.toString(),
      ApiKeys.totalReviews: totalReviews,
      ApiKeys.isDeleted: isDeleted,
      if (createdAt != null) ApiKeys.createdAt: createdAt!.toIso8601String(),
      if (updatedAt != null) ApiKeys.updatedAt: updatedAt!.toIso8601String(),
      if (category != null)
        ApiKeys.category: {
          ApiKeys.id: category!.id,
          ApiKeys.categoryName: category!.categoryName,
          if (category!.parentId != null) ApiKeys.parentId: category!.parentId,
        },
      if (productImages.isNotEmpty)
        ApiKeys.productImages:
            productImages
                .map(
                  (img) =>
                      img is ProductImageModel
                          ? img.toJson()
                          : {
                            if (img.id.isNotEmpty) ApiKeys.id: img.id,
                            if (img.productId != 0)
                              ApiKeys.productId: img.productId,
                            ApiKeys.url: img.url,
                            ApiKeys.isPrimary: img.isPrimary,
                          },
                )
                .toList(),
    };
  }
}
