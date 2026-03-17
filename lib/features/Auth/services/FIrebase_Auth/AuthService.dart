import 'package:cartwala/Models/user_model.dart';
import 'package:cartwala/features/Auth/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cartwala/firebase_options.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign up with email + password, then sync to MongoDB.
  Future<AppUser?> createUserwithEmailandPassword(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
    String phone = '',
    String role = 'buyer',
    String jazzcashNumber = '',
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(name);
      await cred.user?.reload();

      try {
        // Sync to MongoDB
        final appUser = await UserService.syncUser(
          name: name,
          email: email,
          phone: phone,
          role: role,
          jazzcashNumber: jazzcashNumber,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Signed up successfully"),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
        return appUser;
      } catch (e) {
        // Rollback Firebase user creation if backend sync fails
        await cred.user?.delete();
        rethrow;
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String message = e.message ?? "Authentication failed.";
        if (e.code == 'email-already-in-use') {
          message = "This email is already in use.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    return null;
  }

  /// Sign in with email + password, then sync to MongoDB.
  Future<AppUser?> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) return null;

      // Sync to MongoDB
      final appUser = await UserService.syncUser(
        name: user.displayName ?? 'User',
        email: user.email ?? email,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Signed in successfully"),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
      return appUser;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String message = e.message ?? "Authentication failed.";
        if (e.code == 'user-not-found' ||
            e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          message = "Invalid email or password.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    return null;
  }

  Future<void> signout() async {
    await _auth.signOut();
  }

  /// Google sign-in, then sync to MongoDB.
  Future<AppUser?> signUpWithGoogle(
    BuildContext context, {
    String role = 'buyer',
  }) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      final String? serverClientId =
          DefaultFirebaseOptions.android.androidClientId;

      if (serverClientId == null || serverClientId.isEmpty) {
        throw Exception(
          'Google Sign-In is not configured: missing Android server client ID.',
        );
      }

      await googleSignIn.initialize(serverClientId: serverClientId);
      final googleUser = await googleSignIn.authenticate();

      if (googleUser == null) {
        return null; // User cancelled sign-in
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) return null;

      try {
        // Sync to MongoDB
        final appUser = await UserService.syncUser(
          name: user.displayName ?? 'User',
          email: user.email ?? '',
          role: role,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Signed in with Google successfully"),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );
        }
        return appUser;
      } catch (e) {
        await user.delete(); // Rollback on backend sync failure
        await googleSignIn.signOut();
        rethrow;
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? "Google Sign-in failed"),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            duration: const Duration(seconds: 4),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    return null;
  }
}
