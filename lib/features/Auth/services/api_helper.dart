import 'package:firebase_auth/firebase_auth.dart';

/// Returns the current Firebase ID token for API calls.
/// Returns empty string if not logged in.
Future<String> getFirebaseToken() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return '';
  return await user.getIdToken() ?? '';
}

/// Standard auth headers for API requests.
Future<Map<String, String>> authHeaders() async {
  final token = await getFirebaseToken();
  return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
}
