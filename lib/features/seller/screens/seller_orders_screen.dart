import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/order_model.dart';
import 'package:cartwala/Models/store_model.dart';
import 'package:cartwala/features/order/services/order_service.dart';
import 'package:flutter/material.dart';

class SellerOrdersScreen extends StatefulWidget {
  final Store store;
  const SellerOrdersScreen({super.key, required this.store});

  @override
  State<SellerOrdersScreen> createState() => _SellerOrdersScreenState();
}

class _SellerOrdersScreenState extends State<SellerOrdersScreen> {
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
      _orders = await OrderService.getSellerOrders();
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
                  'Orders',
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
                      itemBuilder: (_, i) => _orderCard(_orders[i]),
                    ),
                  ),
          ),
        ],
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
            // Order header
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
                      fontSize: 11,
                      color: _statusColor(order.status),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Buyer info
            Text(
              'Buyer: ${order.buyerName}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Address: ${order.shippingAddress}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 8),

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

            // Payment screenshot if uploaded
            if (order.paymentScreenshotUrl.isNotEmpty &&
                order.status == 'paid') ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _showScreenshotDialog(order.paymentScreenshotUrl),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long, color: Colors.blue, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'View Payment Screenshot',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Action buttons
            const SizedBox(height: 12),
            _buildActions(order),
          ],
        ),
      ),
    );
  }

  Widget _buildActions(Order order) {
    switch (order.status) {
      case 'paid':
        return Row(
          children: [
            Expanded(
              child: _actionButton(
                'Confirm Payment',
                AppColors.lime,
                Colors.black,
                () => _confirmOrder(order.id!),
              ),
            ),
          ],
        );
      case 'confirmed':
        return Row(
          children: [
            Expanded(
              child: _actionButton(
                'Mark Shipped',
                AppColors.headerDark,
                Colors.white,
                () => _updateStatus(order.id!, 'shipped'),
              ),
            ),
          ],
        );
      case 'shipped':
        return Row(
          children: [
            Expanded(
              child: _actionButton(
                'Mark Delivered',
                AppColors.emerald,
                Colors.white,
                () => _updateStatus(order.id!, 'delivered'),
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _actionButton(
    String label,
    Color bg,
    Color fg,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Future<void> _confirmOrder(String orderId) async {
    try {
      await OrderService.confirmOrder(orderId);
      _loadOrders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _updateStatus(String orderId, String status) async {
    try {
      await OrderService.updateStatus(orderId, status);
      _loadOrders();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _showScreenshotDialog(String url) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('Failed to load image'),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Close',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
