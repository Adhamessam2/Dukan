import '../../../../core/api/api_keys.dart';
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
      id: json[ApiKeys.id]?.toString() ?? '',
      productId: (json[ApiKeys.productId] as num?)?.toInt() ?? 0,
      url: json[ApiKeys.url] as String? ?? '',
      isPrimary: json[ApiKeys.isPrimary] as bool? ?? false,
      order: (json[ApiKeys.order] as num?)?.toInt(),
      originalName: json[ApiKeys.originalName] as String?,
      mimeType: json[ApiKeys.mimeType] as String?,
      size: (json[ApiKeys.size] as num?)?.toInt(),
      storageKey: json[ApiKeys.storageKey] as String?,
      provider: json[ApiKeys.provider] as String?,
      createdAt: json[ApiKeys.createdAt] is String
          ? DateTime.tryParse(json[ApiKeys.createdAt] as String)
          : null,
    );
  }
}
