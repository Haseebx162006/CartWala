import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/store_model.dart';
import 'package:cartwala/features/store/services/store_service.dart';
import 'package:flutter/material.dart';

class CreateStoreScreen extends StatefulWidget {
  final void Function(Store store) onStoreCreated;

  const CreateStoreScreen({super.key, required this.onStoreCreated});

  @override
  State<CreateStoreScreen> createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _logoUrlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _logoUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final store = await StoreService.createStore(
        storeName: _nameController.text.trim(),
        description: _descController.text.trim(),
        logoUrl: _logoUrlController.text.trim(),
      );
      widget.onStoreCreated(store);
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.storefront_rounded,
                  size: 56,
                  color: AppColors.lime,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Create Your Store',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Set up your store to start selling on Cartwala',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                _buildField(
                  controller: _nameController,
                  label: 'Store Name',
                  icon: Icons.store_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Store name is required'
                      : null,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _descController,
                  label: 'Description (optional)',
                  icon: Icons.description_rounded,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildField(
                  controller: _logoUrlController,
                  label: 'Logo URL (optional)',
                  icon: Icons.image_rounded,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
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
                            'Create Store',
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
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.lime, width: 2),
        ),
      ),
    );
  }
}
