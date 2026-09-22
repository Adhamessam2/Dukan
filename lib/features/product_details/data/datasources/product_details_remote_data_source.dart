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
    if (response is! Map || response['data'] is! Map) {
      throw ParseException(message: 'Invalid response: missing data');
    }
    final data = response['data'];
    return ProductModel.fromJson(Map<String, dynamic>.from(data as Map));
  }
}
