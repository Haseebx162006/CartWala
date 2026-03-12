class AppUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role; // buyer, seller, admin
  final String jazzcashNumber;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    required this.role,
    this.jazzcashNumber = '',
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'buyer',
      jazzcashNumber: json['jazzcashNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'jazzcashNumber': jazzcashNumber,
  };

  bool get isSeller => role == 'seller';
  bool get isAdmin => role == 'admin';
  bool get isBuyer => role == 'buyer';
}
