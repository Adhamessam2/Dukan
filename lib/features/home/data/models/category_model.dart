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
      id: (json['id'] as num?)?.toInt() ?? 0,
      categoryName: (json['categoryName'] as String?)?.trim() ?? '',
      parentId: (json['parentId'] as num?)?.toInt(),
      parent: json['parent'] is Map
          ? CategoryModel.fromJson(
              Map<String, dynamic>.from(json['parent'] as Map),
            )
          : null,
      subCategories:
          (json['subCategories'] as List<dynamic>?)
              ?.whereType<Map>()
              .map(
                (subJson) =>
                    CategoryModel.fromJson(Map<String, dynamic>.from(subJson)),
              )
              .toList() ??
          const [],
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] is String
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }
}
