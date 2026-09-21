import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

enum OrdersStatus { initial, loading, success, failure }

enum OrdersFilterTab { all, pending, processing, shipped, delivered, cancelled }

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<OrderEntity> orders;
  final OrdersFilterTab selectedFilter;
  final String searchQuery;
  final String? errorMessage;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.selectedFilter = OrdersFilterTab.all,
    this.searchQuery = '',
    this.errorMessage,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderEntity>? orders,
    OrdersFilterTab? selectedFilter,
    String? searchQuery,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  /// Returns the filtered orders based on active tab and search query.
  List<OrderEntity> get filteredOrders {
    var result = orders;

    // Filter by tab
    switch (selectedFilter) {
      case OrdersFilterTab.all:
        break;
      case OrdersFilterTab.pending:
        result = result.where((o) => o.isPending).toList();
        break;
      case OrdersFilterTab.processing:
        result = result.where((o) => o.isProcessing).toList();
        break;
      case OrdersFilterTab.shipped:
        result = result.where((o) => o.isShipped).toList();
        break;
      case OrdersFilterTab.delivered:
        result = result.where((o) => o.isDelivered).toList();
        break;
      case OrdersFilterTab.cancelled:
        result = result.where((o) => o.isCancelled).toList();
        break;
    }

    // Filter by search query
    final query = searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      result = result.where((o) {
        final idStr = o.id.toString();
        final dkIdStr = '#dk-$idStr';
        if (idStr.contains(query) || dkIdStr.contains(query)) {
          return true;
        }
        final matchesProduct = o.items.any(
          (item) => item.product.productName.toLowerCase().contains(query),
        );
        return matchesProduct;
      }).toList();
    }

    return result;
  }

  /// Number of in-progress shipments for the header indicator pill.
  int get activeShipmentsCount => orders.where((o) => o.isInProgress).length;

  @override
  List<Object?> get props => [
    status,
    orders,
    selectedFilter,
    searchQuery,
    errorMessage,
  ];
}
