import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/server_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../home/data/models/product_model.dart';

/// Remote data source contract for product details operations
abstract class ProductDetailsRemoteDataSource {
  Future<ProductModel> getProductById(int id);
}

class ProductDetailsRemoteDataSourceImpl
    implements ProductDetailsRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProductDetailsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await apiConsumer.get(ServerStrings.productById(id));
    if (response is! Map) {
      throw ParseException(message: 'Invalid response format for product');
    }
    final success = response['success'] as bool? ?? true;
    if (!success) {
      final statusCode = (response['statusCode'] as num?)?.toInt() ?? 404;
      final message = response['message'] as String? ?? 'Product not found';
      if (statusCode == 404) {
        throw NotFoundException(message: message);
      }
      throw ServerException(message: message, statusCode: statusCode);
    }
    final data = response['data'];
    if (data is! Map) {
      throw ParseException(message: 'Invalid product data');
    }
    return ProductModel.fromJson(Map<String, dynamic>.from(data));
  }
}
