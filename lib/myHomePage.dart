import 'package:cartwala/features/auth/services/FIrebase_Auth/AuthService.dart';
import 'package:flutter/material.dart';

class myHomePage extends StatefulWidget {
  const myHomePage({super.key});

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Heloo Welcomee", style: TextStyle(fontSize: 40)),
          SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              signout();
            },
            child: Text("Signout"),
          ),
        ],
      ),
    );
  }
}
