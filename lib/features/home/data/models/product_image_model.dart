import '../../domain/entities/product_image_entity.dart';

/// Data model representing a product image, extending [ProductImageEntity]
class ProductImageModel extends ProductImageEntity {
  const ProductImageModel({
    required super.id,
    required super.productId,
    required super.url,
    super.isPrimary = false,
    super.order,
    super.originalName,
    super.mimeType,
    super.size,
    super.storageKey,
    super.provider,
    super.createdAt,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id']?.toString() ?? '',
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      url: json['url'] as String? ?? '',
      isPrimary: json['isPrimary'] as bool? ?? false,
      order: (json['order'] as num?)?.toInt(),
      originalName: json['originalName'] as String?,
      mimeType: json['mimeType'] as String?,
      size: (json['size'] as num?)?.toInt(),
      storageKey: json['storageKey'] as String?,
      provider: json['provider'] as String?,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}
