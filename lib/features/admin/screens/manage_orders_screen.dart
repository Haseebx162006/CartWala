import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/order_model.dart';
import 'package:cartwala/features/order/services/order_service.dart';
import 'package:flutter/material.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  List<Order> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _loading = true);
    try {
      _orders = await OrderService.getAllOrders();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.blue;
      case 'confirmed':
        return AppColors.lime;
      case 'shipped':
        return AppColors.teal;
      case 'delivered':
        return AppColors.emerald;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
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
                  'All Orders',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  onPressed: _loadOrders,
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
                : _orders.isEmpty
                ? const Center(
                    child: Text(
                      'No orders yet',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    color: AppColors.lime,
                    onRefresh: _loadOrders,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _orderTile(_orders[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _orderTile(Order order) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Order #${(order.id ?? '').substring(0, 8)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(order.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: _statusColor(order.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Buyer: ${order.buyerName} (${order.buyerEmail})',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Items: ${order.items.length} · Total: Rs ${order.totalAmount.toStringAsFixed(0)}',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          if (order.createdAt != null) ...[
            const SizedBox(height: 4),
            Text(
              'Date: ${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
