import 'dart:convert';
import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/store_model.dart';
import 'package:cartwala/features/Auth/services/api_helper.dart';
import 'package:http/http.dart' as http;

class StoreService {
  static Future<Store> createStore({
    required String storeName,
    String description = '',
    String logoUrl = '',
  }) async {
    final headers = await authHeaders();
    final res = await http.post(
      Uri.parse('$kBaseUrl/api/stores'),
      headers: headers,
      body: jsonEncode({
        'storeName': storeName,
        'description': description,
        'logoUrl': logoUrl,
      }),
    );
    if (res.statusCode == 201) return Store.fromJson(jsonDecode(res.body));
    throw Exception(
      jsonDecode(res.body)['message'] ?? 'Failed to create store',
    );
  }

  static Future<Store?> getMyStore() async {
    final headers = await authHeaders();
    final res = await http.get(
      Uri.parse('$kBaseUrl/api/stores/mine'),
      headers: headers,
    );
    if (res.statusCode == 200) return Store.fromJson(jsonDecode(res.body));
    return null;
  }

  static Future<Store> updateStore({
    String? storeName,
    String? description,
    String? logoUrl,
  }) async {
    final headers = await authHeaders();
    final body = <String, dynamic>{};
    if (storeName != null) body['storeName'] = storeName;
    if (description != null) body['description'] = description;
    if (logoUrl != null) body['logoUrl'] = logoUrl;

    final res = await http.put(
      Uri.parse('$kBaseUrl/api/stores/mine'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) return Store.fromJson(jsonDecode(res.body));
    throw Exception('Failed to update store');
  }

  static Future<List<Store>> getAllStores() async {
    final res = await http.get(Uri.parse('$kBaseUrl/api/stores'));
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List;
      return list.map((e) => Store.fromJson(e)).toList();
    }
    throw Exception('Failed to fetch stores');
  }

  static Future<Store> getStoreById(String id) async {
    final res = await http.get(Uri.parse('$kBaseUrl/api/stores/$id'));
    if (res.statusCode == 200) return Store.fromJson(jsonDecode(res.body));
    throw Exception('Store not found');
  }
}
