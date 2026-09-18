import 'package:equatable/equatable.dart';

/// Domain entity representing a category and its optional subcategories
class CategoryEntity extends Equatable {
  final int id;
  final String categoryName;
  final int? parentId;
  final CategoryEntity? parent;
  final List<CategoryEntity> subCategories;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CategoryEntity({
    required this.id,
    required this.categoryName,
    this.parentId,
    this.parent,
    this.subCategories = const [],
    this.isDeleted = false,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    categoryName,
    parentId,
    parent,
    subCategories,
    isDeleted,
    createdAt,
    updatedAt,
  ];
}
