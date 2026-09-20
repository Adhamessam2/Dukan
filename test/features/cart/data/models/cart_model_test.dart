import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/cart/data/models/cart_item_model.dart';
import 'package:Dukan/features/cart/data/models/cart_model.dart';
import 'package:Dukan/features/cart/domain/entities/cart_entity.dart';
import 'package:Dukan/features/home/data/models/product_model.dart';

void main() {
  const tProductModel = ProductModel(
    id: 1,
    productName: 'Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE) 📱',
    price: 9999.99,
  );

  const tCartItemModel = CartItemModel(
    productId: 1,
    quantity: 3,
    product: tProductModel,
  );

  const tCartModel = CartModel(
    id: 4,
    items: [tCartItemModel],
    totalPrice: 29999.97,
  );

  test('should be a subclass of CartEntity', () {
    expect(tCartModel, isA<CartEntity>());
  });

  test('fromJson should return valid model from JSON map', () {
    final jsonMap = {
      'id': 4,
      'items': [
        {
          'productId': 1,
          'quantity': 3,
          'product': {
            'id': 1,
            'productName':
                '  Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE) 📱 ',
            'price': '9999.99',
          },
        },
      ],
      'totalPrice': '29999.97',
    };

    final result = CartModel.fromJson(jsonMap);

    expect(result.id, equals(4));
    expect(result.totalPrice, equals(29999.97));
    expect(result.items.length, equals(1));
    expect(result.items.first.productId, equals(1));
    expect(result.items.first.quantity, equals(3));
    expect(result.items.first.product?.id, equals(1));
    expect(
      result.items.first.product?.productName,
      equals('Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE) 📱'),
    );
    expect(result.items.first.product?.price, equals(9999.99));
  });
}
