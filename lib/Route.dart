import 'package:cartwala/features/Auth/screens/LoginScreen.dart';
import 'package:cartwala/features/Auth/screens/SignUp.dart';
import 'package:cartwala/features/Product/screens/add_product_screen.dart';
import 'package:cartwala/features/order/screens/my_orders_screen.dart';
import 'package:flutter/material.dart';

const String myOrdersRoute = '/my-orders';

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
        builder: (context) => const LoginScreen(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AddProductScreen(),
      );
    case myOrdersRoute:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const MyOrdersScreen(),
      );
  }

  return MaterialPageRoute(
    builder: (context) => const Scaffold(body: Text("Route not found")),
  );
}
