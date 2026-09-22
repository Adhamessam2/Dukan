import '../../domain/entities/create_order_params.dart';

class CreateOrderRequestModel {
  final String shippingCity;
  final String shippingStreet;
  final String shippingBuilding;
  final String paymentMethod;

  const CreateOrderRequestModel({
    required this.shippingCity,
    required this.shippingStreet,
    required this.shippingBuilding,
    required this.paymentMethod,
  });

  factory CreateOrderRequestModel.fromEntity(CreateOrderParams params) {
    return CreateOrderRequestModel(
      shippingCity: params.address.city,
      shippingStreet: params.address.street,
      shippingBuilding: params.address.building,
      paymentMethod: params.paymentMethod.value,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': {
        'shippingCity': shippingCity,
        'shippingStreet': shippingStreet,
        'shippingBuilding': shippingBuilding,
      },
      'paymentMethod': paymentMethod,
    };
  }
}
