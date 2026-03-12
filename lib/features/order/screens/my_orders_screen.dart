import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/order_model.dart';
import 'package:cartwala/features/order/services/order_service.dart';
import 'package:flutter/material.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
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
      _orders = await OrderService.getMyOrders();
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
        return AppColors.limeDark;
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

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Awaiting Payment';
      case 'paid':
        return 'Payment Submitted';
      case 'confirmed':
        return 'Confirmed by Seller';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Orders',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.lime),
            )
          : _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No orders yet',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: AppColors.lime,
              onRefresh: _loadOrders,
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: _orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) => _orderCard(_orders[i]),
              ),
            ),
    );
  }

  Widget _orderCard(Order order) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${(order.id ?? '').substring(0, 8)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(order.status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(order.status),
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
            const Divider(height: 20),

            // Items
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.name} x${item.quantity}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'Rs ${(item.price * item.quantity).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 16),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Rs ${order.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.limeDark,
                  ),
                ),
              ],
            ),

            // Status tracker
            const SizedBox(height: 16),
            _buildStatusTracker(order.status),

            // Cancel button for pending orders
            if (order.status == 'pending') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _cancelOrder(order.id!),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Cancel Order',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],

            if (order.createdAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'Placed on ${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTracker(String status) {
    final steps = ['pending', 'paid', 'confirmed', 'shipped', 'delivered'];
    final currentIdx = steps.indexOf(status);

    if (status == 'cancelled') {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_rounded, color: AppColors.error, size: 18),
            SizedBox(width: 8),
            Text(
              'Order Cancelled',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: List.generate(steps.length, (i) {
        final isComplete = i <= currentIdx;
        final isLast = i == steps.length - 1;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isComplete ? AppColors.lime : AppColors.divider,
                ),
                child: isComplete
                    ? const Icon(Icons.check, size: 12, color: Colors.black)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: i < currentIdx ? AppColors.lime : AppColors.divider,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _cancelOrder(String orderId) async {
    try {
      await OrderService.cancelOrder(orderId);
      _loadOrders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
