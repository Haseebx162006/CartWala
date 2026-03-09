import 'package:cartwala/features/auth/screens/LoginScreen.dart';
import 'package:cartwala/features/auth/screens/Signup.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Signup.SignupScreen:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => Signup(),
      );
    case LoginScreen.login_screen:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => LoginScreen(),
      );
  }

  return MaterialPageRoute(
    builder: (context) =>
        const Scaffold(body: Text("Material Page doesnot exist ")),
  );
}
