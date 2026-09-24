import '../../../../core/api/api_keys.dart';
import '../../domain/entities/pagination_meta_entity.dart';

/// Data model representing pagination metadata, extending [PaginationMetaEntity]
class PaginationMetaModel extends PaginationMetaEntity {
  const PaginationMetaModel({
    required super.page,
    required super.limit,
    required super.total,
    required super.totalPages,
    required super.hasNextPage,
    required super.hasPreviousPage,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    return PaginationMetaModel(
      page:
          (json[ApiKeys.page] as num?)?.toInt() ??
          int.tryParse(json[ApiKeys.page]?.toString() ?? '1') ??
          1,
      limit:
          (json[ApiKeys.limit] as num?)?.toInt() ??
          int.tryParse(json[ApiKeys.limit]?.toString() ?? '10') ??
          10,
      total:
          (json[ApiKeys.total] as num?)?.toInt() ??
          int.tryParse(json[ApiKeys.total]?.toString() ?? '0') ??
          0,
      totalPages:
          (json[ApiKeys.totalPages] as num?)?.toInt() ??
          int.tryParse(json[ApiKeys.totalPages]?.toString() ?? '1') ??
          1,
      hasNextPage: json[ApiKeys.hasNextPage] is bool
          ? json[ApiKeys.hasNextPage] as bool
          : json[ApiKeys.hasNextPage]?.toString().toLowerCase() == 'true',
      hasPreviousPage: json[ApiKeys.hasPreviousPage] is bool
          ? json[ApiKeys.hasPreviousPage] as bool
          : json[ApiKeys.hasPreviousPage]?.toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ApiKeys.page: page,
      ApiKeys.limit: limit,
      ApiKeys.total: total,
      ApiKeys.totalPages: totalPages,
      ApiKeys.hasNextPage: hasNextPage,
      ApiKeys.hasPreviousPage: hasPreviousPage,
    };
  }
}
