import '../../../../core/api/api_keys.dart';
import '../../domain/entities/category_entity.dart';

/// Data model representing a category, extending [CategoryEntity]
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.categoryName,
    super.parentId,
    super.parent,
    super.subCategories = const [],
    super.isDeleted = false,
    super.createdAt,
    super.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json[ApiKeys.id] as num?)?.toInt() ?? 0,
      categoryName: (json[ApiKeys.categoryName] as String?)?.trim() ?? '',
      parentId: (json[ApiKeys.parentId] as num?)?.toInt(),
      parent: json[ApiKeys.parent] is Map
          ? CategoryModel.fromJson(
              Map<String, dynamic>.from(json[ApiKeys.parent] as Map),
            )
          : null,
      subCategories:
          (json[ApiKeys.subCategories] as List<dynamic>?)
              ?.whereType<Map>()
              .map(
                (subJson) =>
                    CategoryModel.fromJson(Map<String, dynamic>.from(subJson)),
              )
              .toList() ??
          const [],
      isDeleted: json[ApiKeys.isDeleted] as bool? ?? false,
      createdAt: json[ApiKeys.createdAt] is String
          ? DateTime.tryParse(json[ApiKeys.createdAt] as String)
          : null,
      updatedAt: json[ApiKeys.updatedAt] is String
          ? DateTime.tryParse(json[ApiKeys.updatedAt] as String)
          : null,
    );
  }
}
