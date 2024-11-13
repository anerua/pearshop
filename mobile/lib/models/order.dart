import 'package:mobile/models/cart_item.dart';

class Order {
  final int id;
  final String deliveryAddress;
  final DateTime createdAt;
  final List<CartItem> items;
  final double total;

  Order({
    required this.id,
    required this.deliveryAddress,
    required this.createdAt,
    required this.items,
    required this.total,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      deliveryAddress: json['delivery_address'],
      createdAt: DateTime.parse(json['created_at']),
      items: (json['order_items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      total: double.parse(json['total_price'].toString()),
    );
  }
}
