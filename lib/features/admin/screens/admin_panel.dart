import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Providers/userProvider.dart';
import 'package:cartwala/features/admin/screens/manage_orders_screen.dart';
import 'package:cartwala/features/admin/screens/manage_stores_screen.dart';
import 'package:cartwala/features/admin/screens/manage_users_screen.dart';
import 'package:cartwala/features/Auth/screens/LoginScreen.dart';
import 'package:cartwala/features/Auth/services/FIrebase_Auth/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminPanel extends ConsumerStatefulWidget {
  const AdminPanel({super.key});

  @override
  ConsumerState<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends ConsumerState<AdminPanel> {
  int _currentIndex = 0;

  late final _pages = [
    _AdminDashboardTab(onNavigate: (i) => setState(() => _currentIndex = i)),
    const ManageUsersScreen(),
    const ManageStoresScreen(),
    const ManageOrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.lime,
        unselectedItemColor: AppColors.textSecondary,
        backgroundColor: AppColors.surface,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_rounded),
            label: 'Stores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}

class _AdminDashboardTab extends ConsumerWidget {
  const _AdminDashboardTab({required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                      'Hello, ${user?.name ?? 'Admin'}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Admin Dashboard',
                      style: TextStyle(
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
                    if (context.mounted) {
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
            const SizedBox(height: 28),

            // Admin banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    color: AppColors.lime,
                    size: 36,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Cartwala Admin',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage users, stores and orders from here',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Manage',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _tile(
              icon: Icons.people_rounded,
              label: 'Users',
              subtitle: 'View all users and their roles',
              onTap: () => onNavigate(1),
            ),
            const SizedBox(height: 12),
            _tile(
              icon: Icons.store_rounded,
              label: 'Stores',
              subtitle: 'View all seller stores',
              onTap: () => onNavigate(2),
            ),
            const SizedBox(height: 12),
            _tile(
              icon: Icons.receipt_long_rounded,
              label: 'Orders',
              subtitle: 'Track all platform orders',
              onTap: () => onNavigate(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lime.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.limeDark, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
