import 'package:cartwala/features/auth/screens/SignUp.dart';
import 'package:cartwala/features/auth/services/FIrebase_Auth/AuthService.dart';
import 'package:cartwala/widgets/auth_button.dart';
import 'package:cartwala/widgets/auth_container.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const login_screen = 'login-auth';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool ischeck = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),
            Text(
              "Sign In",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 50,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Sign in to your account and start shopping!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 18),
            SizedBox(height: 10),
            Text(
              " Email",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            AuthContainer(
              hinttext: "Email",
              controller: emailController,
              obsecuretext: false,
            ),
            SizedBox(height: 10),

            Text(
              " Password",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            AuthContainer(
              hinttext: "Password",
              controller: passwordController,
              obsecuretext: true,
            ),
            SizedBox(height: 15),
            AuthButton(
              text: "Sign In",
              onPressed: () => {
                Authservice().signInWithEmailAndPassword(
                  context,
                  emailController.text.trim(),
                  passwordController.text.trim(),
                ),
              },
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "───────────────── OR ─────────────────",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Authservice().signUpWithGoogle(context);
                    },
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
                          SizedBox(width: 6),
                          Text(
                            "Google",
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
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
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
                          SizedBox(width: 6),
                          Text(
                            "Google",
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
                ),
              ],
            ),
            SizedBox(height: 200),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dont have an account? ",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Signup()),
                    );
                  },
                  child: Text(
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
