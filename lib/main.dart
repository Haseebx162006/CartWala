import 'package:cartwala/GlobalVariables.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Amazon Clone",
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: ColorScheme.light(primary: GlobalVariables.secondaryColor),
        appBarTheme: AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Amazon", style: TextStyle(fontSize: 23))),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(height: 100, width: 100, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
