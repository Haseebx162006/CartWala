import 'package:cartwala/Models/user_model.dart';
import 'package:cartwala/features/Auth/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

      // Sync to MongoDB
      final appUser = await UserService.syncUser(
        name: name,
        email: email,
        phone: phone,
        role: role,
        jazzcashNumber: jazzcashNumber,
      );
      return appUser;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.message}"),
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), duration: Duration(seconds: 4)),
      );
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
      return appUser;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.message}"),
          duration: Duration(seconds: 4),
        ),
      );
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
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;
      if (user == null) return null;

      // Sync to MongoDB
      final appUser = await UserService.syncUser(
        name: user.displayName ?? 'User',
        email: user.email ?? '',
        role: role,
      );
      return appUser;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.message}"),
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), duration: Duration(seconds: 4)),
      );
    }
    return null;
  }
}
