import 'package:cartwala/features/auth/screens/Signup.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Signup.SignupScreen:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => Signup(),
      );
  }

  return MaterialPageRoute(
    builder: (context) =>
        const Scaffold(body: Text("Material Page doesnot exist ")),
  );
}
