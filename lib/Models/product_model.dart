class Product {
  final String? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final int stock;
  final bool isActive;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    this.imageUrl = '',
    this.stock = 0,
    this.isActive = true,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      imageUrl: json['imageUrl'],
      stock: json['stock'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'stock': stock,
      'isActive': isActive,
    };
  }
}
