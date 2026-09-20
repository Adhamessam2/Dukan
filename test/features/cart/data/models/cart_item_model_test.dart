import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/cart/data/models/cart_item_model.dart';
import 'package:Dukan/features/cart/domain/entities/cart_item_entity.dart';

void main() {
  const tCartItemModel = CartItemModel(
    cartId: 1,
    productId: 10,
    quantity: 2,
    isDeleted: false,
  );

  test('should be a subclass of CartItemEntity', () {
    expect(tCartItemModel, isA<CartItemEntity>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON has all fields', () {
      final jsonMap = {
        'cartId': 1,
        'productId': 10,
        'quantity': 2,
        'isDeleted': false,
      };

      final result = CartItemModel.fromJson(jsonMap);

      expect(result, equals(tCartItemModel));
    });

    test(
      'should return a valid model with default values when JSON fields are null',
      () {
        final jsonMap = <String, dynamic>{
          'cartId': null,
          'productId': null,
          'quantity': null,
          'isDeleted': null,
        };

        final result = CartItemModel.fromJson(jsonMap);

        expect(result.cartId, isNull);
        expect(result.productId, equals(0));
        expect(result.quantity, equals(1));
        expect(result.isDeleted, equals(false));
      },
    );

    test('should parse num values as int correctly', () {
      final jsonMap = {
        'cartId': 5.0,
        'productId': 12.0,
        'quantity': 3.0,
        'isDeleted': true,
      };

      final result = CartItemModel.fromJson(jsonMap);

      expect(result.cartId, equals(5));
      expect(result.productId, equals(12));
      expect(result.quantity, equals(3));
      expect(result.isDeleted, equals(true));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing only productId and quantity', () {
      final result = tCartItemModel.toJson();

      final expectedJsonMap = {'productId': 10, 'quantity': 2};

      expect(result, equals(expectedJsonMap));
    });
  });
}
