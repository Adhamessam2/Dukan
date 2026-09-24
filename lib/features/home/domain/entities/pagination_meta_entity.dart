import 'package:equatable/equatable.dart';

/// Domain entity representing pagination metadata
class PaginationMetaEntity extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  const PaginationMetaEntity({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  @override
  List<Object?> get props => [
    page,
    limit,
    total,
    totalPages,
    hasNextPage,
    hasPreviousPage,
  ];
}
