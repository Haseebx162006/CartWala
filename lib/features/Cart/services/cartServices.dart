import 'dart:convert';
import 'package:cartwala/Models/product_model.dart';
import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/features/Auth/services/api_helper.dart';
import 'package:http/http.dart' as http;

class CartService {
  final String baseUrl = kBaseUrl;

  List<Product> _parseCartItems(http.Response response) {
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData['items'] as List)
          .map((item) => Product.fromJson(item))
          .toList();
    }
    return [];
  }

  Future<List<Product>> fetchCart() async {
    final headers = await authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/api/cart'),
      headers: headers,
    );
    return _parseCartItems(response);
  }

  Future<List<Product>> addProductToCart(Product product) async {
    final headers = await authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/api/cart/add'),
      headers: headers,
      body: jsonEncode({'productId': product.id, 'quantity': 1}),
    );
    return _parseCartItems(response);
  }

  Future<List<Product>> removeProductFromCart(String productId) async {
    final headers = await authHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/cart/remove'),
      headers: headers,
      body: jsonEncode({'productId': productId}),
    );
    return _parseCartItems(response);
  }

  Future<List<Product>> updateProductQuantity(
    String productId,
    int quantity,
  ) async {
    final headers = await authHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/api/cart/update'),
      headers: headers,
      body: jsonEncode({'productId': productId, 'quantity': quantity}),
    );
    return _parseCartItems(response);
  }
}
