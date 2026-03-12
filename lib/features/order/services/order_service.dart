import 'dart:convert';
import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/order_model.dart';
import 'package:cartwala/features/Auth/services/api_helper.dart';
import 'package:http/http.dart' as http;

class OrderService {
  /// Place a new order.
  static Future<Order> placeOrder({
    required String storeId,
    required List<Map<String, dynamic>> items,
    required String shippingAddress,
  }) async {
    final headers = await authHeaders();
    final res = await http.post(
      Uri.parse('$kBaseUrl/api/orders'),
      headers: headers,
      body: jsonEncode({
        'storeId': storeId,
        'items': items,
        'shippingAddress': shippingAddress,
      }),
    );
    if (res.statusCode == 201) return Order.fromJson(jsonDecode(res.body));
    throw Exception(jsonDecode(res.body)['message'] ?? 'Failed to place order');
  }

  /// Upload payment screenshot URL.
  static Future<Order> uploadPaymentProof({
    required String orderId,
    required String paymentScreenshotUrl,
  }) async {
    final headers = await authHeaders();
    final res = await http.post(
      Uri.parse('$kBaseUrl/api/orders/pay'),
      headers: headers,
      body: jsonEncode({
        'orderId': orderId,
        'paymentScreenshotUrl': paymentScreenshotUrl,
      }),
    );
    if (res.statusCode == 200) return Order.fromJson(jsonDecode(res.body));
    throw Exception(
      jsonDecode(res.body)['message'] ?? 'Failed to upload proof',
    );
  }

  /// Buyer: get my orders.
  static Future<List<Order>> getMyOrders() async {
    final headers = await authHeaders();
    final res = await http.get(
      Uri.parse('$kBaseUrl/api/orders/mine'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((e) => Order.fromJson(e))
          .toList();
    }
    throw Exception('Failed to fetch orders');
  }

  /// Seller: get orders for my store.
  static Future<List<Order>> getSellerOrders() async {
    final headers = await authHeaders();
    final res = await http.get(
      Uri.parse('$kBaseUrl/api/orders/seller'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((e) => Order.fromJson(e))
          .toList();
    }
    throw Exception('Failed to fetch seller orders');
  }

  /// Seller: confirm a paid order.
  static Future<Order> confirmOrder(String orderId) async {
    final headers = await authHeaders();
    final res = await http.post(
      Uri.parse('$kBaseUrl/api/orders/confirm'),
      headers: headers,
      body: jsonEncode({'orderId': orderId}),
    );
    if (res.statusCode == 200) return Order.fromJson(jsonDecode(res.body));
    throw Exception(jsonDecode(res.body)['message'] ?? 'Failed to confirm');
  }

  /// Seller: update status (shipped/delivered).
  static Future<Order> updateStatus(String orderId, String status) async {
    final headers = await authHeaders();
    final res = await http.post(
      Uri.parse('$kBaseUrl/api/orders/status'),
      headers: headers,
      body: jsonEncode({'orderId': orderId, 'status': status}),
    );
    if (res.statusCode == 200) return Order.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update status');
  }

  /// Cancel order.
  static Future<Order> cancelOrder(String orderId) async {
    final headers = await authHeaders();
    final res = await http.post(
      Uri.parse('$kBaseUrl/api/orders/cancel'),
      headers: headers,
      body: jsonEncode({'orderId': orderId}),
    );
    if (res.statusCode == 200) return Order.fromJson(jsonDecode(res.body));
    throw Exception('Failed to cancel order');
  }

  /// Admin: get all orders.
  static Future<List<Order>> getAllOrders() async {
    final headers = await authHeaders();
    final res = await http.get(
      Uri.parse('$kBaseUrl/api/orders/all'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return (jsonDecode(res.body) as List)
          .map((e) => Order.fromJson(e))
          .toList();
    }
    throw Exception('Failed to fetch all orders');
  }
}
