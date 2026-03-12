import 'package:cartwala/Models/product_model.dart';
import 'package:cartwala/features/Cart/services/cartServices.dart';
import 'package:flutter_riverpod/legacy.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]) {
    fetchCart(); // Load cart on init
  }

  final CartService _cartService = CartService();

  // Fetch cart from backend
  Future<void> fetchCart() async {
    try {
      final items = await _cartService.fetchCart();
      state = [...items]; // trigger UI rebuild
    } catch (e) {
      print('Failed to fetch cart: $e');
    }
  }

  // Add product
  Future<void> addToCart(Product product) async {
    try {
      final updatedItems = await _cartService.addProductToCart(product);
      state = [...updatedItems];
    } catch (e) {
      print('Failed to add product: $e');
    }
  }

  // Remove product
  Future<void> removeFromCart(String productId) async {
    try {
      final updatedItems = await _cartService.removeProductFromCart(productId);
      state = [...updatedItems];
    } catch (e) {
      print('Failed to remove product: $e');
    }
  }

  // Update quantity
  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      final updatedItems = await _cartService.updateProductQuantity(
        productId,
        quantity,
      );
      state = [...updatedItems];
    } catch (e) {
      print('Failed to update quantity: $e');
    }
  }

  // Clear cart locally
  void clearCart() {
    state = [];
  }
}
