import 'package:equatable/equatable.dart';
import 'category_model.dart';

/// Response wrapper model for categories endpoint
class CategoriesResponseModel extends Equatable {
  final bool success;
  final int statusCode;
  final List<CategoryModel> data;
  final String? message;

  const CategoriesResponseModel({
    required this.success,
    required this.statusCode,
    required this.data,
    this.message,
  });

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoriesResponseModel(
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message'] as String?,
      data:
          (json['data'] as List<dynamic>?)
              ?.whereType<Map>()
              .map(
                (item) =>
                    CategoryModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList() ??
          const [],
    );
  }

  @override
  List<Object?> get props => [success, statusCode, data, message];
}
