import 'package:cartwala/Models/product_model.dart';

class Cart {
  final String user_id;
  final List<Product> items;

  const Cart({required this.user_id, required this.items});
  factory Cart.fromjson(Map<String, dynamic> json) {
    return Cart(
      user_id: json['user_id'],
      items: (json['items'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user_id': user_id,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
