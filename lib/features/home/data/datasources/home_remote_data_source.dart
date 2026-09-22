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
      throw ParseException(message: 'Invalid response: expected Map');
    }
    return CategoriesResponseModel.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  @override
  Future<ProductsResponseModel> getProducts() async {
    final response = await apiConsumer.get(ServerStrings.products);
    if (response is! Map) {
      throw ParseException(message: 'Invalid response: expected Map');
    }
    return ProductsResponseModel.fromJson(Map<String, dynamic>.from(response));
  }

  @override
  Future<CategoryModel> getCategoryById(int id) async {
    final response = await apiConsumer.get(ServerStrings.categoryById(id));
    if (response is! Map || response['data'] is! Map) {
      throw ParseException(message: 'Invalid response: missing data');
    }
    final data = response['data'];
    return CategoryModel.fromJson(Map<String, dynamic>.from(data as Map));
  }
}
