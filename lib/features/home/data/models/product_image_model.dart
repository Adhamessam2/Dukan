import '../../../../core/api/api_keys.dart';
import '../../domain/entities/product_image_entity.dart';

/// Data model representing a product image, extending [ProductImageEntity]
class ProductImageModel extends ProductImageEntity {
  const ProductImageModel({
    super.id = '',
    super.productId = 0,
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

  factory ProductImageModel.fromJson(
    Map<String, dynamic> json, {
    int defaultProductId = 0,
    bool defaultIsPrimary = false,
  }) {
    final parsedProductId =
        (json[ApiKeys.productId] as num?)?.toInt() ??
        int.tryParse(json[ApiKeys.productId]?.toString() ?? '') ??
        defaultProductId;

    final isPrimaryValue = json[ApiKeys.isPrimary];
    final isPrimary =
        isPrimaryValue is bool
            ? isPrimaryValue
            : isPrimaryValue != null
                ? isPrimaryValue.toString().toLowerCase() == 'true'
                : defaultIsPrimary;

    return ProductImageModel(
      id: json[ApiKeys.id]?.toString() ?? '',
      productId: parsedProductId,
      url: (json[ApiKeys.url] as String?)?.trim() ?? '',
      isPrimary: isPrimary,
      order:
          (json[ApiKeys.order] as num?)?.toInt() ??
          int.tryParse(json[ApiKeys.order]?.toString() ?? ''),
      originalName: json[ApiKeys.originalName] as String?,
      mimeType: json[ApiKeys.mimeType] as String?,
      size:
          (json[ApiKeys.size] as num?)?.toInt() ??
          int.tryParse(json[ApiKeys.size]?.toString() ?? ''),
      storageKey: json[ApiKeys.storageKey] as String?,
      provider: json[ApiKeys.provider] as String?,
      createdAt:
          json[ApiKeys.createdAt] is String
              ? DateTime.tryParse(json[ApiKeys.createdAt] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) ApiKeys.id: id,
      if (productId != 0) ApiKeys.productId: productId,
      ApiKeys.url: url,
      ApiKeys.isPrimary: isPrimary,
      if (order != null) ApiKeys.order: order,
      if (originalName != null) ApiKeys.originalName: originalName,
      if (mimeType != null) ApiKeys.mimeType: mimeType,
      if (size != null) ApiKeys.size: size,
      if (storageKey != null) ApiKeys.storageKey: storageKey,
      if (provider != null) ApiKeys.provider: provider,
      if (createdAt != null) ApiKeys.createdAt: createdAt!.toIso8601String(),
    };
  }
}
