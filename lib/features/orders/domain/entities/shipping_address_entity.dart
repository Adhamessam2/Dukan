import 'package:equatable/equatable.dart';

class ShippingAddressEntity extends Equatable {
  final String city;
  final String street;
  final String building;

  const ShippingAddressEntity({
    required this.city,
    required this.street,
    required this.building,
  });

  @override
  List<Object?> get props => [city, street, building];
}
