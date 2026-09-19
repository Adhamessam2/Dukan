import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/server_strings.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/categories_response_model.dart';
import '../models/category_model.dart';
import '../models/products_response_model.dart';

/// Contract for Home remote operations
abstract class HomeRemoteDataSource {
  Future<CategoriesResponseModel> getCategories();
  Future<ProductsResponseModel> getProducts();
  Future<CategoryModel> getCategoryById(int id);
}

/// Implementation of [HomeRemoteDataSource] using [ApiConsumer]
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiConsumer apiConsumer;

  HomeRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<CategoriesResponseModel> getCategories() async {
    final response = await apiConsumer.get(ServerStrings.categories);
    if (response is! Map) {
      throw ParseException(message: 'Invalid response format for categories');
    }
    return CategoriesResponseModel.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  @override
  Future<ProductsResponseModel> getProducts() async {
    final response = await apiConsumer.get(ServerStrings.products);
    if (response is! Map) {
      throw ParseException(message: 'Invalid response format for products');
    }
    return ProductsResponseModel.fromJson(Map<String, dynamic>.from(response));
  }

  @override
  Future<CategoryModel> getCategoryById(int id) async {
    final response = await apiConsumer.get(ServerStrings.categoryById(id));
    if (response is! Map) {
      throw ParseException(message: 'Invalid response format for category');
    }
    final success = response['success'] as bool? ?? true;
    if (!success) {
      final statusCode = (response['statusCode'] as num?)?.toInt() ?? 404;
      final message = response['message'] as String? ?? 'Category not found';
      if (statusCode == 404) {
        throw NotFoundException(message: message);
      }
      throw ServerException(
        message: message,
        statusCode: statusCode,
      );
    }
    final data = response['data'];
    if (data is! Map) {
      throw ParseException(message: 'Invalid category data');
    }
    return CategoryModel.fromJson(Map<String, dynamic>.from(data));
  }
}
