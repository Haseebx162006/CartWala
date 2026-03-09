import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> createUserwithEmailandPassword(
  BuildContext context,
  String name,
  String email,
  String password,
) async {
  try {
    final userCredential = await FirebaseAuth.instance
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
    final loggedUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
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

Future<void> signUpWithGoogle(BuildContext context) async {
  try {
    await FirebaseAuth.instance.goo
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Error: ${e.message}"),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
