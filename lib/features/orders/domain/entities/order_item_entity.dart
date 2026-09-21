import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/product_entity.dart';

class OrderItemEntity extends Equatable {
  final int quantity;
  final ProductEntity product;

  const OrderItemEntity({required this.quantity, required this.product});

  @override
  List<Object?> get props => [quantity, product];
}
