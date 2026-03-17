import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Providers/userProvider.dart';
import 'package:cartwala/features/Auth/services/FIrebase_Auth/AuthService.dart';
import 'package:cartwala/widgets/auth_button.dart';
import 'package:cartwala/widgets/auth_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Signup extends ConsumerStatefulWidget {
  static const SignupScreen = 'signup-auth';

  Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  bool ischeck = false;
  String _selectedRole = 'buyer';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController jazzcashController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    jazzcashController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();
    final jazzcash = jazzcashController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name, email and password are required')),
      );
      return;
    }

    if (_selectedRole == 'seller' && jazzcash.length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid JazzCash number (11 digits)'),
        ),
      );
      return;
    }

    final appUser = await Authservice().createUserwithEmailandPassword(
      context,
      name: name,
      email: email,
      password: password,
      phone: phone,
      role: _selectedRole,
      jazzcashNumber: jazzcash,
    );

    if (appUser != null && mounted) {
      ref
          .read(userProvider.notifier)
          .syncUser(
            name: appUser.name,
            email: appUser.email,
            phone: appUser.phone,
            role: appUser.role,
            jazzcashNumber: appUser.jazzcashNumber,
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
              "Sign Up",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 50,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Create an account and Join Us!",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 18),

            // ── Role Selection ──────────────────────────────────
            const Text(
              " I want to join as",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _roleChip('buyer', 'Buyer', Icons.shopping_bag_outlined),
                const SizedBox(width: 12),
                _roleChip('seller', 'Seller', Icons.storefront_outlined),
              ],
            ),
            const SizedBox(height: 16),

            _label("Name"),
            const SizedBox(height: 8),
            AuthContainer(
              hinttext: "Name",
              controller: nameController,
              obsecuretext: false,
            ),
            const SizedBox(height: 10),
            _label("Email"),
            const SizedBox(height: 8),
            AuthContainer(
              hinttext: "Email",
              controller: emailController,
              obsecuretext: false,
            ),
            const SizedBox(height: 10),
            _label("Password"),
            const SizedBox(height: 8),
            AuthContainer(
              hinttext: "Password",
              controller: passwordController,
              obsecuretext: true,
            ),
            const SizedBox(height: 10),
            _label("Phone"),
            const SizedBox(height: 8),
            AuthContainer(
              hinttext: "Phone number",
              controller: phoneController,
              obsecuretext: false,
            ),

            // ── JazzCash (seller only) ──────────────────────────
            if (_selectedRole == 'seller') ...[
              const SizedBox(height: 10),
              _label("JazzCash Number"),
              const SizedBox(height: 8),
              AuthContainer(
                hinttext: "03XXXXXXXXX",
                controller: jazzcashController,
                obsecuretext: false,
                iconData: Icons.account_balance_wallet_outlined,
              ),
            ],

            const SizedBox(height: 7),
            Row(
              children: [
                Checkbox(
                  value: ischeck,
                  onChanged: (v) => setState(() => ischeck = v!),
                ),
                const Text(
                  "I agree to the Terms and Conditions",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            AuthButton(text: "Sign Up", onPressed: _handleSignup),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final appUser = await Authservice().signUpWithGoogle(
                        context,
                        role: _selectedRole,
                      );
                      if (appUser != null && mounted) {
                        ref
                            .read(userProvider.notifier)
                            .syncUser(
                              name: appUser.name,
                              email: appUser.email,
                              role: appUser.role,
                            );
                      }
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
                          const SizedBox(width: 6),
                          const Text(
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
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Sign In",
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    " $text",
    style: const TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),
  );

  Widget _roleChip(String value, String label, IconData icon) {
    final selected = _selectedRole == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.lime : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.limeDark : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected
                    ? AppColors.headerDark
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 15,
                  color: selected
                      ? AppColors.headerDark
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
