import 'package:cartwala/Models/user_model.dart';
import 'package:cartwala/features/Auth/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

final userProvider = StateNotifierProvider<UserNotifier, AppUser?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<AppUser?> {
  UserNotifier() : super(null) {
    // Initialize from Firebase current user if exists
    _initFromFirebase();
  }

  void _initFromFirebase() {
    final fbUser = FirebaseAuth.instance.currentUser;
    if (fbUser != null) {
      // Create a basic user from Firebase (source of truth for auth)
      state = AppUser(
        id: fbUser.uid,
        name: fbUser.displayName ?? 'User',
        email: fbUser.email ?? '',
        phone: '',
        role: 'buyer', // Default role until loaded from MongoDB
        jazzcashNumber: '',
      );
      // Load full profile from MongoDB in background
      _loadProfileInBackground();
    }
  }

  /// Load additional profile info from MongoDB in background.
  /// If this fails, user stays authenticated using Firebase info.
  void _loadProfileInBackground() {
    Future(() async {
      try {
        final user = await UserService.getProfile();
        if (user != null) {
          state = user;
        }
      } catch (e) {
        // Silent fail - keep Firebase-based user info
        print('Failed to load MongoDB profile: $e');
      }
    });
  }

  /// Load profile from backend (called on app start if Firebase user exists).
  Future<void> loadProfile() async {
    _loadProfileInBackground();
  }

  /// Sync user to MongoDB in background after authentication.
  /// Firebase is the source of truth, MongoDB is optional metadata.
  void syncUserInBackground({
    required String name,
    required String email,
    String phone = '',
    String role = 'buyer',
    String jazzcashNumber = '',
  }) {
    // Fire and forget - don't await
    Future(() async {
      try {
        final user = await UserService.syncUser(
          name: name,
          email: email,
          phone: phone,
          role: role,
          jazzcashNumber: jazzcashNumber,
        );
        // Update state with full MongoDB user
        state = user;
      } catch (e) {
        // Silent fail - user stays logged in via Firebase
        // If MongoDB sync fails, use the data from Firebase
        print('MongoDB sync failed: $e');
        // Keep the Firebase-based user info instead of clearing
      }
    });
  }

  void clear() => state = null;
}
