class Store {
  final String? id;
  final String sellerFirebaseUid;
  final String storeName;
  final String description;
  final String logoUrl;
  final String jazzcashNumber;
  final bool isActive;

  const Store({
    this.id,
    required this.sellerFirebaseUid,
    required this.storeName,
    this.description = '',
    this.logoUrl = '',
    required this.jazzcashNumber,
    this.isActive = true,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['_id'] ?? json['id'],
      sellerFirebaseUid: json['sellerFirebaseUid'] ?? '',
      storeName: json['storeName'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      jazzcashNumber: json['jazzcashNumber'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
    'storeName': storeName,
    'description': description,
    'logoUrl': logoUrl,
  };
}
