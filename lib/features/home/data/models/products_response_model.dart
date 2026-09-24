import 'package:equatable/equatable.dart';
import '../../../../core/api/api_keys.dart';
import 'pagination_meta_model.dart';
import 'product_model.dart';

export 'pagination_meta_model.dart';

/// Data payload model containing products list and pagination metadata
class ProductsDataModel extends Equatable {
  final List<ProductModel> data;
  final PaginationMetaModel? meta;

  const ProductsDataModel({
    required this.data,
    this.meta,
  });

  factory ProductsDataModel.fromJson(Map<String, dynamic> json) {
    final rawList = json[ApiKeys.data];
    final products =
        rawList is List
            ? rawList
                .whereType<Map>()
                .map(
                  (item) =>
                      ProductModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
            : const <ProductModel>[];

    final meta =
        json[ApiKeys.meta] is Map
            ? PaginationMetaModel.fromJson(
              Map<String, dynamic>.from(json[ApiKeys.meta] as Map),
            )
            : null;

    return ProductsDataModel(data: products, meta: meta);
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.data: data.map((item) => item.toJson()).toList(),
      if (meta != null) ApiKeys.meta: meta!.toJson(),
    };
  }

  @override
  List<Object?> get props => [data, meta];
}

/// Response wrapper model for products endpoint
class ProductsResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final List<ProductModel> data;
  final PaginationMetaModel? meta;
  final String? message;

  const ProductsResponseModel({
    required this.success,
    required this.statusCode,
    required this.data,
    this.meta,
    this.message,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    List<ProductModel> products = const [];
    PaginationMetaModel? meta;

    final rawData = json[ApiKeys.data];
    if (rawData is Map) {
      final rawMap = Map<String, dynamic>.from(rawData);
      final rawList = rawMap[ApiKeys.data];
      if (rawList is List) {
        products =
            rawList
                .whereType<Map>()
                .map(
                  (item) =>
                      ProductModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList();
      }
      if (rawMap[ApiKeys.meta] is Map) {
        meta = PaginationMetaModel.fromJson(
          Map<String, dynamic>.from(rawMap[ApiKeys.meta] as Map),
        );
      }
    } else if (rawData is List) {
      products =
          rawData
              .whereType<Map>()
              .map(
                (item) =>
                    ProductModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
    }

    if (meta == null && json[ApiKeys.meta] is Map) {
      meta = PaginationMetaModel.fromJson(
        Map<String, dynamic>.from(json[ApiKeys.meta] as Map),
      );
    }

    return ProductsResponseModel(
      success: json[ApiKeys.success] as bool? ?? false,
      statusCode: (json[ApiKeys.statusCode] as num?)?.toInt() ?? 200,
      message: json[ApiKeys.message] as String?,
      data: products,
      meta: meta,
    );
  }

  /// Convenience getter for typed data payload
  ProductsDataModel get productsData =>
      ProductsDataModel(data: data, meta: meta);

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.success: success,
      ApiKeys.statusCode: statusCode,
      if (message != null) ApiKeys.message: message,
      ApiKeys.data: {
        ApiKeys.data: data.map((item) => item.toJson()).toList(),
        if (meta != null) ApiKeys.meta: meta!.toJson(),
      },
    };
  }

  @override
  List<Object?> get props => [success, statusCode, data, meta, message];
}
