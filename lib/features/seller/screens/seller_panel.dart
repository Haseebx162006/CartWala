import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/store_model.dart';
import 'package:cartwala/Providers/userProvider.dart';
import 'package:cartwala/features/Auth/services/FIrebase_Auth/AuthService.dart';
import 'package:cartwala/features/Auth/screens/LoginScreen.dart';
import 'package:cartwala/features/seller/screens/create_store_screen.dart';
import 'package:cartwala/features/seller/screens/seller_orders_screen.dart';
import 'package:cartwala/features/seller/screens/seller_products_screen.dart';
import 'package:cartwala/features/store/services/store_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerPanel extends ConsumerStatefulWidget {
  const SellerPanel({super.key});

  @override
  ConsumerState<SellerPanel> createState() => _SellerPanelState();
}

class _SellerPanelState extends ConsumerState<SellerPanel> {
  int _currentIndex = 0;
  Store? _store;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStore();
  }

  Future<void> _loadStore() async {
    try {
      final store = await StoreService.getMyStore();
      setState(() {
        _store = store;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.lime)),
      );
    }

    // If seller has no store yet, show create store screen
    if (_store == null) {
      return CreateStoreScreen(
        onStoreCreated: (store) {
          setState(() => _store = store);
        },
      );
    }

    final pages = [
      _buildDashboard(user?.name ?? 'Seller'),
      SellerProductsScreen(store: _store!),
      SellerOrdersScreen(store: _store!),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: AppColors.lime,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.surface,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(String sellerName) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, $sellerName',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _store!.storeName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () async {
                    await Authservice().signout();
                    ref.read(userProvider.notifier).clear();
                    if (mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        LoginScreen.login_screen,
                        (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                  tooltip: 'Logout',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Store info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.store_rounded,
                        color: AppColors.lime,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _store!.storeName,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_store!.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _store!.description,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone_android,
                        color: AppColors.lime,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'JazzCash: ${_store!.jazzcashNumber}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _store!.isActive
                          ? AppColors.lime
                          : AppColors.error,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _store!.isActive ? 'Active' : 'Inactive',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _actionCard(
                    icon: Icons.add_box_rounded,
                    label: 'Add Product',
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionCard(
                    icon: Icons.receipt_long_rounded,
                    label: 'View Orders',
                    onTap: () => setState(() => _currentIndex = 2),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.lime, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
