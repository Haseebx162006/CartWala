import 'dart:convert';
import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/product_model.dart';
import 'package:cartwala/features/Auth/services/api_helper.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$kBaseUrl/api/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // POST create a product (with auth for seller)
  static Future<Product> createProduct(Product product) async {
    final headers = await authHeaders();
    final response = await http.post(
      Uri.parse('$kBaseUrl/api/createproduct'),
      headers: headers,
      body: jsonEncode(product.toJson()),
    );
    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to create product');
    }
  }

  // Get products by store
  static Future<List<Product>> getProductsByStore(String storeId) async {
    final response = await http.get(
      Uri.parse('$kBaseUrl/api/products/store/$storeId'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load store products');
    }
  }

  // Get my products (seller)
  static Future<List<Product>> getMyProducts() async {
    final headers = await authHeaders();
    final response = await http.get(
      Uri.parse('$kBaseUrl/api/products/mine'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load my products');
    }
  }

  static Future<void> deleteProduct(String id) async {
    final headers = await authHeaders();
    final response = await http.delete(
      Uri.parse('$kBaseUrl/api/products/$id'),
      headers: headers,
    );
    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to delete product');
    }
  }
}
