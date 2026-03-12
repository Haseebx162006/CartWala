import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Providers/productProvider.dart';
import 'package:cartwala/widgets/FlashCard.dart';
import 'package:cartwala/widgets/ProductCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class myHomePage extends ConsumerStatefulWidget {
  const myHomePage({super.key});

  @override
  ConsumerState<myHomePage> createState() => _myHomePageState();
}

class _myHomePageState extends ConsumerState<myHomePage> {
  final TextEditingController searchController = TextEditingController();
  List<String> discounts = ["50%", "30%", "70%"];
  List<String> subtitles = ["On electronics", "On clothing", "On groceries"];
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(ProductProvider.notifier).fetchProducts();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(ProductProvider);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " Hello",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),

              Text(
                " Welcome to Cartwala",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 5),
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
                "  Categories",
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
              SizedBox(
                height: 160,
                child: ListView.builder(
                  itemCount: 3,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return FlashCard(
                      discount: discounts[index],
                      subTitle: subtitles[index],
                    );
                  },
                ),
              ),
              SizedBox(height: 5),
              Text(
                "   Products",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GridView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(
                    productName: products[index].name,
                    productPrice: products[index].price,
                    imageUrl: products[index].imageUrl,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
