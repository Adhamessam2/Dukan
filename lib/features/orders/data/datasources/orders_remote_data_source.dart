import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/server_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/create_order_params.dart';
import '../models/create_order_request_model.dart';
import '../models/order_model.dart';
import '../models/order_payment_status_model.dart';

abstract class OrdersRemoteDataSource {
  Future<OrderModel> createOrder(CreateOrderParams params);
  Future<List<OrderModel>> getOrders();
  Future<OrderModel> getOrderById(int id);
  Future<OrderModel> cancelOrder(int id);
  Future<OrderPaymentStatusModel> getOrderPaymentStatus(int id);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiConsumer apiConsumer;

  OrdersRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<OrderModel> createOrder(CreateOrderParams params) async {
    final response = await apiConsumer.post(
      ServerStrings.order,
      headers: {'Idempotency-Key': params.idempotencyKey},
      body: CreateOrderRequestModel.fromEntity(params).toJson(),
    );

    if (response is Map && response['success'] == false) {
      throw ServerException(
        message: response['message']?.toString() ?? 'Failed to create order',
      );
    }

    if (response is Map && response['data'] is Map) {
      return OrderModel.fromJson(
        Map<String, dynamic>.from(response['data'] as Map),
      );
    }
    throw ParseException(message: 'Invalid response: missing order data');
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final response = await apiConsumer.get(ServerStrings.order);

    if (response is Map && response['success'] == false) {
      throw ServerException(
        message: response['message']?.toString() ?? 'Failed to fetch orders',
      );
    }

    if (response is Map && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map>()
          .map((item) => OrderModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    throw ParseException(message: 'Invalid response: missing orders list');
  }

  @override
  Future<OrderModel> getOrderById(int id) async {
    final response = await apiConsumer.get(ServerStrings.orderById(id));

    if (response is Map && response['success'] == false) {
      throw ServerException(
        message: response['message']?.toString() ?? 'Order not found',
      );
    }

    if (response is Map && response['data'] is Map) {
      return OrderModel.fromJson(
        Map<String, dynamic>.from(response['data'] as Map),
      );
    }
    throw ParseException(message: 'Invalid response: missing order data');
  }

  @override
  Future<OrderModel> cancelOrder(int id) async {
    final response = await apiConsumer.patch(ServerStrings.cancelOrder(id));

    if (response is Map && response['success'] == false) {
      throw ServerException(
        message: response['message']?.toString() ?? 'Failed to cancel order',
      );
    }

    if (response is Map && response['data'] is Map) {
      return OrderModel.fromJson(
        Map<String, dynamic>.from(response['data'] as Map),
      );
    }
    throw ParseException(message: 'Invalid response: missing order data');
  }

  @override
  Future<OrderPaymentStatusModel> getOrderPaymentStatus(int id) async {
    final response = await apiConsumer.get(
      ServerStrings.orderPaymentStatus(id),
    );

    if (response is Map && response['success'] == false) {
      throw ServerException(
        message:
            response['message']?.toString() ?? 'Failed to fetch payment status',
      );
    }

    if (response is Map && response['data'] is Map) {
      return OrderPaymentStatusModel.fromJson(
        Map<String, dynamic>.from(response['data'] as Map),
      );
    }
    throw ParseException(
      message: 'Invalid response: missing payment status data',
    );
  }
}
