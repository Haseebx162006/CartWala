import 'package:cartwala/Providers/userProvider.dart';
import 'package:cartwala/features/Auth/screens/SignUp.dart';
import 'package:cartwala/features/Auth/services/FIrebase_Auth/AuthService.dart';
import 'package:cartwala/widgets/auth_button.dart';
import 'package:cartwala/widgets/auth_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const login_screen = 'login-auth';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    final appUser = await Authservice().signInWithEmailAndPassword(
      context,
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    // User is now authenticated in Firebase. StreamBuilder will handle navigation.
    if (appUser != null && mounted) {
      // Sync to MongoDB in background (non-blocking)
      // If this fails, user stays logged in since Firebase auth is our source of truth
      ref
          .read(userProvider.notifier)
          .syncUserInBackground(name: appUser.name, email: appUser.email);
    }
  }

  Future<void> _handleGoogleLogin() async {
    final appUser = await Authservice().signUpWithGoogle(context);
    // User is now authenticated in Firebase. StreamBuilder will handle navigation.
    if (appUser != null && mounted) {
      // Sync to MongoDB in background (non-blocking)
      // If this fails, user stays logged in since Firebase auth is our source of truth
      ref
          .read(userProvider.notifier)
          .syncUserInBackground(
            name: appUser.name,
            email: appUser.email,
            role: appUser.role,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              "Sign In",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 50,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Sign in to your account and start shopping!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              " Email",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            AuthContainer(
              hinttext: "Email",
              controller: emailController,
              obsecuretext: false,
            ),
            const SizedBox(height: 10),
            const Text(
              " Password",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            AuthContainer(
              hinttext: "Password",
              controller: passwordController,
              obsecuretext: true,
            ),
            const SizedBox(height: 15),
            AuthButton(text: "Sign In", onPressed: _handleLogin),
            const SizedBox(height: 14),
            Row(
              children: [
                const Expanded(
                  child: Divider(color: Colors.grey, thickness: 1),
                ),
                const SizedBox(width: 8),
                const Text(
                  "OR",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Divider(color: Colors.grey, thickness: 1),
                ),
              ],
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _handleGoogleLogin,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/google.png",
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account? ",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Signup()),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
