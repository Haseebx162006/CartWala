import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/features/auth/services/FIrebase_Auth/AuthService.dart';
import 'package:flutter/material.dart';

class myHomePage extends StatefulWidget {
  const myHomePage({super.key});

  @override
  State<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends State<myHomePage> {
  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: 20,
                color: Colors.black,
              ),
            ),

            Text(
              "Welcome to Cartwala",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 5),
            // how to add search bar here
            SearchBar(
              hintText: "Search for products",
              padding: WidgetStatePropertyAll(
                EdgeInsets.only(left: 10, right: 10),
              ),
              leading: Icon(Icons.search),
              controller: searchController,
              trailing: [
                IconButton(
                  onPressed: () {
                    searchController.clear();
                  },
                  icon: Icon(Icons.clear),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "Categories",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: GlobalVariables.secondaryColor,
                    child: Icon(Icons.phone_android, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: GlobalVariables.secondaryColor,
                    child: Icon(Icons.checkroom, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: GlobalVariables.secondaryColor,
                    child: Icon(Icons.dining, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 1),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: GlobalVariables.secondaryColor,
                    child: Icon(Icons.sports_cricket, color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: GlobalVariables.secondaryColor,
                    child: Icon(Icons.toys, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
           
          ],
        ),
      ),
    );
  }
}
