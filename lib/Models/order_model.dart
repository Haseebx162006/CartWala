class OrderItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl = '',
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] ?? 1,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
  };
}

class Order {
  final String? id;
  final String buyerFirebaseUid;
  final String buyerName;
  final String buyerEmail;
  final String buyerPhone;
  final String sellerFirebaseUid;
  final String storeId;
  final List<OrderItem> items;
  final double totalAmount;
  final String shippingAddress;
  final String sellerJazzcashNumber;
  final String paymentScreenshotUrl;
  final String
  status; // pending, paid, confirmed, shipped, delivered, cancelled
  final DateTime? createdAt;

  const Order({
    this.id,
    required this.buyerFirebaseUid,
    required this.buyerName,
    required this.buyerEmail,
    this.buyerPhone = '',
    required this.sellerFirebaseUid,
    required this.storeId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.sellerJazzcashNumber,
    this.paymentScreenshotUrl = '',
    this.status = 'pending',
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? json['id'],
      buyerFirebaseUid: json['buyerFirebaseUid'] ?? '',
      buyerName: json['buyerName'] ?? '',
      buyerEmail: json['buyerEmail'] ?? '',
      buyerPhone: json['buyerPhone'] ?? '',
      sellerFirebaseUid: json['sellerFirebaseUid'] ?? '',
      storeId: json['storeId'] ?? '',
      items: (json['items'] as List? ?? [])
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      shippingAddress: json['shippingAddress'] ?? '',
      sellerJazzcashNumber: json['sellerJazzcashNumber'] ?? '',
      paymentScreenshotUrl: json['paymentScreenshotUrl'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
