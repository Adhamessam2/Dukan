import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/server_strings.dart';
import '../../../home/data/models/product_model.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartItemModel> addToCart({
    required int productId,
    required int quantity,
  });

  Future<CartModel> getCart();

  Future<ProductModel> getCartItem({
    required String cartId,
    required String productId,
  });

  Future<CartItemModel> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  });

  Future<CartItemModel> deleteCartItem({
    required String cartId,
    required String productId,
  });

  Future<int> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiConsumer apiConsumer;

  CartRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<CartItemModel> addToCart({
    required int productId,
    required int quantity,
  }) async {
    final response = await apiConsumer.post(
      ServerStrings.cartItem,
      body: {'productId': productId, 'quantity': quantity},
    );

    return CartItemModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  @override
  Future<CartModel> getCart() async {
    final response = await apiConsumer.get(ServerStrings.cart);

    return CartModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  @override
  Future<ProductModel> getCartItem({
    required String cartId,
    required String productId,
  }) async {
    final response = await apiConsumer.get(
      ServerStrings.cartItem,
      queryParameters: {'cartId': cartId, 'productId': productId},
    );

    return ProductModel.fromJson(
      Map<String, dynamic>.from(response['data']['product'] as Map),
    );
  }

  @override
  Future<CartItemModel> updateCartItem({
    required String cartId,
    required String productId,
    required int quantity,
  }) async {
    final response = await apiConsumer.put(
      ServerStrings.cartItem,
      queryParameters: {'cartId': cartId, 'productId': productId},
      body: {
        'productId': int.tryParse(productId) ?? productId,
        'quantity': quantity,
      },
    );

    return CartItemModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  @override
  Future<CartItemModel> deleteCartItem({
    required String cartId,
    required String productId,
  }) async {
    final response = await apiConsumer.delete(
      ServerStrings.cartItem,
      queryParameters: {'cartId': cartId, 'productId': productId},
    );

    return CartItemModel.fromJson(
      Map<String, dynamic>.from(response['data'] as Map),
    );
  }

  @override
  Future<int> clearCart() async {
    final response = await apiConsumer.delete(ServerStrings.cart);

    return response['data']['count'] as int;
  }
}
