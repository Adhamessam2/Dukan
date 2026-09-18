import 'package:equatable/equatable.dart';
import 'product_model.dart';

/// Response wrapper model for products endpoint
class ProductsResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final List<ProductModel> data;
  final String? message;

  const ProductsResponseModel({
    required this.success,
    required this.statusCode,
    required this.data,
    this.message,
  });

  factory ProductsResponseModel.fromJson(Map<String, dynamic> json) {
    return ProductsResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 200,
      message: json['message'] as String?,
      data:
          (json['data'] as List<dynamic>?)
              ?.whereType<Map>()
              .map(
                (item) =>
                    ProductModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [success, statusCode, data, message];
}
