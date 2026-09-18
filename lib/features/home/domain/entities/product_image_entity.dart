import 'package:equatable/equatable.dart';

/// Domain entity representing a product image
class ProductImageEntity extends Equatable {
  final String id;
  final int productId;
  final String url;
  final bool isPrimary;
  final int? order;
  final String? originalName;
  final String? mimeType;
  final int? size;
  final String? storageKey;
  final String? provider;
  final DateTime? createdAt;

  const ProductImageEntity({
    required this.id,
    required this.productId,
    required this.url,
    this.isPrimary = false,
    this.order,
    this.originalName,
    this.mimeType,
    this.size,
    this.storageKey,
    this.provider,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    productId,
    url,
    isPrimary,
    order,
    originalName,
    mimeType,
    size,
    storageKey,
    provider,
    createdAt,
  ];
}
