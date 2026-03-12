import 'package:cartwala/GlobalVariables.dart';
import 'package:flutter/material.dart';

class AuthContainer extends StatelessWidget {
  final String hinttext;
  final IconData? iconData;
  final TextEditingController controller;
  final bool obsecuretext;
  const AuthContainer({
    super.key,
    required this.hinttext,
    this.iconData,
    required this.controller,
    required this.obsecuretext,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obsecuretext,
      decoration: InputDecoration(
        hintText: hinttext,
        prefixIcon: iconData != null ? Icon(iconData) : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: GlobalVariables.secondaryColor, // Default black color
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
