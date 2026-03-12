import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/features/Auth/services/user_service.dart';
import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<Map<String, dynamic>> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    try {
      _users = await UserService.getAllUsers();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  IconData _roleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      case 'seller':
        return Icons.store_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  Color _roleColor(String role) {
    switch (role) {
      case 'admin':
        return AppColors.crimson;
      case 'seller':
        return AppColors.lime;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Users',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: _loadUsers,
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.lime),
                  )
                : RefreshIndicator(
                    color: AppColors.lime,
                    onRefresh: _loadUsers,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _users.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final u = _users[i];
                        final role = u['role'] ?? 'buyer';
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: _roleColor(
                                role,
                              ).withOpacity(0.15),
                              child: Icon(
                                _roleIcon(role),
                                color: _roleColor(role),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              u['name'] ?? 'No Name',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              u['email'] ?? '',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _roleColor(role).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                role.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: _roleColor(role),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
