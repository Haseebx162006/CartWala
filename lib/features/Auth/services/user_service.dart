import 'dart:convert';
import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/user_model.dart';
import 'package:cartwala/features/Auth/services/api_helper.dart';
import 'package:http/http.dart' as http;

class UserService {
  /// Sync Firebase user → MongoDB. Called after signup/login.
  static Future<AppUser> syncUser({
    required String name,
    required String email,
    String phone = '',
    String role = 'buyer',
    String jazzcashNumber = '',
  }) async {
    final headers = await authHeaders();
    final res = await http.post(
      Uri.parse('$kBaseUrl/api/auth/sync'),
      headers: headers,
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
        'jazzcashNumber': jazzcashNumber,
      }),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      return AppUser.fromJson(jsonDecode(res.body));
    }
    throw Exception(jsonDecode(res.body)['message'] ?? 'Sync failed');
  }

  /// Get current user profile from MongoDB.
  static Future<AppUser?> getProfile() async {
    final headers = await authHeaders();
    final res = await http.get(
      Uri.parse('$kBaseUrl/api/auth/profile'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return AppUser.fromJson(jsonDecode(res.body));
    }
    return null; // Not synced yet
  }

  /// Update profile fields.
  static Future<AppUser> updateProfile({
    String? name,
    String? phone,
    String? jazzcashNumber,
  }) async {
    final headers = await authHeaders();
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    if (jazzcashNumber != null) body['jazzcashNumber'] = jazzcashNumber;

    final res = await http.put(
      Uri.parse('$kBaseUrl/api/auth/profile'),
      headers: headers,
      body: jsonEncode(body),
    );
    if (res.statusCode == 200) {
      return AppUser.fromJson(jsonDecode(res.body));
    }
    throw Exception('Failed to update profile');
  }

  /// Admin: get all users.
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final headers = await authHeaders();
    final res = await http.get(
      Uri.parse('$kBaseUrl/api/auth/users'),
      headers: headers,
    );
    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    }
    throw Exception('Failed to fetch users');
  }
}
