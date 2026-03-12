import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/store_model.dart';
import 'package:cartwala/features/store/services/store_service.dart';
import 'package:flutter/material.dart';

class ManageStoresScreen extends StatefulWidget {
  const ManageStoresScreen({super.key});

  @override
  State<ManageStoresScreen> createState() => _ManageStoresScreenState();
}

class _ManageStoresScreenState extends State<ManageStoresScreen> {
  List<Store> _stores = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    setState(() => _loading = true);
    try {
      _stores = await StoreService.getAllStores();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
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
                  'Stores',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: _loadStores,
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
                : _stores.isEmpty
                ? const Center(
                    child: Text(
                      'No stores registered',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: AppColors.lime,
                    onRefresh: _loadStores,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _stores.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _storeTile(_stores[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _storeTile(Store store) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.lime.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.store_rounded,
                  color: AppColors.limeDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.storeName,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (store.description.isNotEmpty)
                      Text(
                        store.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: store.isActive
                      ? AppColors.lime.withOpacity(0.15)
                      : AppColors.error.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  store.isActive ? 'ACTIVE' : 'INACTIVE',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: store.isActive
                        ? AppColors.limeDark
                        : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.phone_android,
                size: 16,
                color: AppColors.textHint,
              ),
              const SizedBox(width: 6),
              Text(
                'JazzCash: ${store.jazzcashNumber}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
