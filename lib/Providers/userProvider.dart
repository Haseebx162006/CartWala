import 'package:cartwala/Models/user_model.dart';
import 'package:cartwala/features/Auth/services/user_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final userProvider = StateNotifierProvider<UserNotifier, AppUser?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AppUser?> {
  UserNotifier() : super(null);

  /// Load profile from backend (called on app start if Firebase user exists).
  Future<void> loadProfile() async {
    try {
      final user = await UserService.getProfile();
      state = user;
    } catch (_) {
      state = null;
    }
  }

  /// Sync after signup/login — creates or fetches MongoDB user.
  Future<AppUser> syncUser({
    required String name,
    required String email,
    String phone = '',
    String role = 'buyer',
    String jazzcashNumber = '',
  }) async {
    final user = await UserService.syncUser(
      name: name,
      email: email,
      phone: phone,
      role: role,
      jazzcashNumber: jazzcashNumber,
    );
    state = user;
    return user;
  }

  void clear() => state = null;
}
