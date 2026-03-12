class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final int stock;
  final bool isActive;
  final int quantity; // used for cart items

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl = '',
    this.stock = 0,
    this.isActive = true,
    this.quantity = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id']?.toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      stock: json['stock'] ?? 0,
      isActive: json['isActive'] ?? true,
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'stock': stock,
      'isActive': isActive,
    };
    if (id != null) map['_id'] = id;
    return map;
  }
}
