import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> createUserwithEmailandPassword(
    BuildContext context,
    String name,
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      print(userCredential.user?.uid);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.message}"),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final UserCredential loggedUser = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(loggedUser.user?.uid);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.message}"),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<User?> signUpWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn.instance
          .authenticate();

      if (googleUser == null) {
        return null;
      }

      final OAuthCredential credential = await GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } on GoogleSignInException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.description ?? e.toString()}"),
          duration: Duration(seconds: 4),
        ),
      );
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
}
