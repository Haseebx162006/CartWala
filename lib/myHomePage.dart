import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/product_model.dart';
import 'package:cartwala/Providers/cartProvider.dart';
import 'package:cartwala/Providers/productProvider.dart';
import 'package:cartwala/Providers/userProvider.dart';
import 'package:cartwala/features/Auth/screens/LoginScreen.dart';
import 'package:cartwala/features/Auth/services/FIrebase_Auth/AuthService.dart';
import 'package:cartwala/features/Product/screens/product_detail_screen.dart';
import 'package:cartwala/features/order/screens/checkout_screen.dart';
import 'package:cartwala/features/order/screens/my_orders_screen.dart';
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
  String _searchQuery = '';
  String? _selectedCategory;
  int _currentNavIndex = 0;

  final List<String> discounts = ["50%", "30%", "70%"];
  final List<String> subtitles = [
    "On electronics",
    "On clothing",
    "On groceries",
  ];

  final List<Map<String, dynamic>> _categories = [
    {'label': 'All', 'icon': Icons.grid_view_rounded},
    {'label': 'Electronics', 'icon': Icons.phone_android_rounded},
    {'label': 'Clothing', 'icon': Icons.checkroom_rounded},
    {'label': 'Grocery', 'icon': Icons.local_grocery_store_rounded},
    {'label': 'Sports', 'icon': Icons.sports_cricket_rounded},
    {'label': 'Toys', 'icon': Icons.toys_rounded},
  ];

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

  List<Product> _filterProducts(List<Product> products) {
    return products.where((p) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == null ||
          _selectedCategory == 'All' ||
          p.category.toLowerCase() == _selectedCategory!.toLowerCase();
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allProducts = ref.watch(ProductProvider);
    final cart = ref.watch(cartProvider);
    final user = ref.watch(userProvider);
    final products = _filterProducts(allProducts);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _buildHomeTab(products, allProducts, user),
          _buildCartTab(cart),
          const MyOrdersScreen(),
          _buildProfileTab(user),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentNavIndex,
        onTap: (i) => setState(() => _currentNavIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.limeDark,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.surface,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 11,
        ),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: cart.isNotEmpty,
              label: Text(
                '${cart.length}',
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
              backgroundColor: AppColors.error,
              child: const Icon(Icons.shopping_cart_rounded),
            ),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HOME TAB
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildHomeTab(
    List<Product> products,
    List<Product> allProducts,
    dynamic user,
  ) {
    return SafeArea(
      child: RefreshIndicator(
        color: AppColors.lime,
        onRefresh: () => ref.read(ProductProvider.notifier).fetchProducts(),
        child: CustomScrollView(
          slivers: [
            // ── Header ────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${user?.name ?? 'Shopper'} 👋',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const Text(
                              'Welcome to Cartwala',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _currentNavIndex = 1),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.lime.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Badge(
                              isLabelVisible: ref
                                  .watch(cartProvider)
                                  .isNotEmpty,
                              label: Text(
                                '${ref.watch(cartProvider).length}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                              backgroundColor: AppColors.error,
                              child: const Icon(
                                Icons.shopping_cart_rounded,
                                color: AppColors.limeDark,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Search bar ─────────────────────────────
                    TextField(
                      controller: searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        hintStyle: const TextStyle(
                          fontFamily: 'Poppins',
                          color: AppColors.textHint,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textSecondary,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.limeDark,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Categories ────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
                child: SizedBox(
                  height: 44,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final selected =
                          (_selectedCategory ?? 'All') == cat['label'];
                      return GestureDetector(
                        onTap: () => setState(
                          () => _selectedCategory = cat['label'] as String,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.headerDark
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: selected
                                  ? AppColors.headerDark
                                  : AppColors.divider,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                cat['icon'] as IconData,
                                size: 18,
                                color: selected
                                    ? AppColors.lime
                                    : AppColors.textSecondary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                cat['label'] as String,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── Flash sale banner ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: discounts.length,
                    itemBuilder: (context, index) {
                      return FlashCard(
                        discount: discounts[index],
                        subTitle: subtitles[index],
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── Section header ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory != null && _selectedCategory != 'All'
                          ? _selectedCategory!
                          : 'All Products',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${products.length} items',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Product grid ──────────────────────────────────────
            if (products.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: AppColors.textHint,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No products found',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final p = products[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(product: p),
                        ),
                      ),
                      child: ProductCard(
                        productName: p.name,
                        productPrice: p.price,
                        imageUrl: p.imageUrl,
                      ),
                    );
                  }, childCount: products.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CART TAB
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildCartTab(List<Product> cart) {
    final total = cart.fold<double>(0, (sum, p) => sum + p.price * p.quantity);

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const Text(
                  'My Cart',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (cart.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lime.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${cart.length} items',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.limeDark,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Cart items
          Expanded(
            child: cart.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: AppColors.textHint,
                        ),
                        SizedBox(height: 14),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Browse products and add items',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    itemCount: cart.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _buildCartItem(item);
                    },
                  ),
          ),

          // Bottom total + checkout
          if (cart.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Rs. ${total.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final cartMaps = cart
                            .map(
                              (p) => {
                                'productId': p.id,
                                'name': p.name,
                                'price': p.price,
                                'quantity': p.quantity,
                              },
                            )
                            .toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CheckoutScreen(
                              storeId: '',
                              sellerJazzcashNumber: '',
                              storeName: 'Cartwala',
                              items: cartMaps,
                              totalAmount: total,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.headerDark,
                        foregroundColor: AppColors.lime,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Checkout',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Product item) {
    final imgUrl = item.imageUrl.isNotEmpty
        ? item.imageUrl
        : 'https://picsum.photos/seed/${Uri.encodeComponent(item.name)}/400/300';
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(14),
            ),
            child: Image.network(
              imgUrl,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 90,
                height: 90,
                color: AppColors.background,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.textHint,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs. ${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.limeDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Quantity controls
                  Row(
                    children: [
                      _qtyButton(Icons.remove, () {
                        if (item.id != null && item.quantity > 1) {
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(item.id!, item.quantity - 1);
                        }
                      }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      _qtyButton(Icons.add, () {
                        if (item.id != null) {
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(item.id!, item.quantity + 1);
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Remove button
          IconButton(
            onPressed: () {
              if (item.id != null) {
                ref.read(cartProvider.notifier).removeFromCart(item.id!);
              }
            },
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.divider),
        ),
        child: Icon(icon, size: 16, color: AppColors.textSecondary),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PROFILE TAB
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildProfileTab(dynamic user) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Avatar
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.lime.withValues(alpha: 0.2),
              child: Text(
                (user?.name ?? 'U')[0].toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  color: AppColors.limeDark,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              user?.name ?? 'Guest',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? '',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (user?.phone != null && (user.phone as String).isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                user.phone as String,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.textHint,
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Tiles
            _profileTile(
              icon: Icons.receipt_long_rounded,
              label: 'My Orders',
              onTap: () => setState(() => _currentNavIndex = 2),
            ),
            const SizedBox(height: 10),
            _profileTile(
              icon: Icons.shopping_cart_rounded,
              label: 'My Cart',
              onTap: () => setState(() => _currentNavIndex = 1),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await Authservice().signout();
                  ref.read(userProvider.notifier).clear();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginScreen.login_screen,
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.logout_rounded, color: AppColors.error),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppColors.error),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.lime.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.limeDark, size: 22),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
