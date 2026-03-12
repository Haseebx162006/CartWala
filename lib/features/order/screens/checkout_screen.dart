import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/features/order/screens/payment_screen.dart';
import 'package:cartwala/features/order/services/order_service.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final String storeId;
  final String sellerJazzcashNumber;
  final String storeName;
  final List<Map<String, dynamic>> items;
  final double totalAmount;

  const CheckoutScreen({
    super.key,
    required this.storeId,
    required this.sellerJazzcashNumber,
    required this.storeName,
    required this.items,
    required this.totalAmount,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter shipping address')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final order = await OrderService.placeOrder(
        storeId: widget.storeId,
        items: widget.items,
        shippingAddress: address,
      );
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentScreen(
              order: order,
              jazzcashNumber: widget.sellerJazzcashNumber,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lime.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.lime.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.store_rounded, color: AppColors.limeDark),
                  const SizedBox(width: 12),
                  Text(
                    widget.storeName,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Order items
            const Text(
              'Order Summary',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item['name']} x${item['quantity']}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      'Rs ${((item['price'] as num) * (item['quantity'] as num)).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Rs ${widget.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColors.limeDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Shipping address
            const Text(
              'Shipping Address',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 3,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Enter your full shipping address',
                hintStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  color: AppColors.textHint,
                ),
                prefixIcon: const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppColors.lime, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Place order button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lime,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Place Order & Pay',
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
    );
  }
}
