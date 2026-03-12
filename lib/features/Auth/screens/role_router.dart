import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/user_model.dart';
import 'package:cartwala/Providers/userProvider.dart';
import 'package:cartwala/features/admin/screens/admin_panel.dart';
import 'package:cartwala/features/seller/screens/seller_panel.dart';
import 'package:cartwala/myHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Routes Firebase-authenticated users to the right panel based on role.
class RoleRouter extends ConsumerStatefulWidget {
  const RoleRouter({super.key});

  @override
  ConsumerState<RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends ConsumerState<RoleRouter> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await ref.read(userProvider.notifier).loadProfile();
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.lime)),
      );
    }

    final AppUser? user = ref.watch(userProvider);

    if (user == null) {
      // Profile not synced yet — default to buyer home
      return const myHomePage();
    }

    switch (user.role) {
      case 'admin':
        return const AdminPanel();
      case 'seller':
        return const SellerPanel();
      default:
        return const myHomePage();
    }
  }
}
