import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/order_model.dart';
import 'package:cartwala/features/order/screens/my_orders_screen.dart';
import 'package:cartwala/features/order/services/order_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentScreen extends StatefulWidget {
  final Order order;
  final String jazzcashNumber;

  const PaymentScreen({
    super.key,
    required this.order,
    required this.jazzcashNumber,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _screenshotUrlController = TextEditingController();
  bool _isLoading = false;
  bool _uploaded = false;

  @override
  void dispose() {
    _screenshotUrlController.dispose();
    super.dispose();
  }

  Future<void> _uploadProof() async {
    final url = _screenshotUrlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter screenshot URL')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await OrderService.uploadPaymentProof(
        orderId: widget.order.id!,
        paymentScreenshotUrl: url,
      );
      setState(() => _uploaded = true);
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
          'Payment',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _uploaded ? _buildSuccessView() : _buildPaymentView(),
      ),
    );
  }

  Widget _buildPaymentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // JazzCash Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE31837), Color(0xFFB71C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE31837).withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'JazzCash',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: Color(0xFFE31837),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.phone_android,
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Send payment to:',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.jazzcashNumber,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: widget.jazzcashNumber),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Number copied!'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, color: Colors.white70),
                    tooltip: 'Copy',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Amount: Rs ${widget.order.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Instructions
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Payment Instructions',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '1. Open JazzCash app on your phone\n'
                '2. Send the exact amount to the number above\n'
                '3. Take a screenshot of the payment confirmation\n'
                '4. Upload the screenshot URL below',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  height: 1.6,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Screenshot URL input
        const Text(
          'Upload Payment Proof',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Paste the URL of your payment screenshot',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _screenshotUrlController,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
          decoration: InputDecoration(
            hintText: 'https://...',
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              color: AppColors.textHint,
            ),
            prefixIcon: const Icon(
              Icons.link_rounded,
              color: AppColors.textSecondary,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.lime, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _uploadProof,
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
                    'Submit Payment Proof',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.lime.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: AppColors.lime,
            size: 72,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Payment Proof Submitted!',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'The seller will review your payment and confirm\nyour order. You\'ll see the updated status\nin "My Orders".',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                (route) => route.isFirst,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lime,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: const Text(
              'View My Orders',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
          child: const Text(
            'Back to Home',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
