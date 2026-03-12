import 'package:cartwala/Models/product_model.dart';
import 'package:cartwala/features/Product/services/product_service.dart';
import 'package:flutter_riverpod/legacy.dart';

final ProductProvider = StateNotifierProvider<ProductNotifier, List<Product>>(
  (ref) => ProductNotifier(),
);

class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  void setProducts(List<Product> products){
    state= products;
  }

  Future<void> fetchProducts() async {
    try{
      final List<Product> products = await ProductService.getProducts();
      setProducts(products);
    }catch(e){
      print("Error fetching products: $e");
    }
  }
}
