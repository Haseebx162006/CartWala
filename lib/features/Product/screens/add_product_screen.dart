import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/product_model.dart';
import 'package:cartwala/features/Product/services/product_service.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatefulWidget {
  static const String routeName = '/add-product';
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _stockController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _submitProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final product = Product(
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        category: _categoryController.text.trim(),
        imageUrl: _imageUrlController.text.trim(),
        stock: int.parse(_stockController.text.trim()),
      );

      await ProductService.createProduct(product);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product created successfully!')),
        );
        Navigator.pop(context, true); // return true to refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
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
          'Add Product',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(_nameController, 'Product Name', Icons.shopping_bag),
              const SizedBox(height: 12),
              _buildField(
                _descController,
                'Description',
                Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildField(
                _priceController,
                'Price',
                Icons.currency_rupee,
                keyboard: TextInputType.number,
                validator: _numberValidator,
              ),
              const SizedBox(height: 12),
              _buildField(_categoryController, 'Category', Icons.category),
              const SizedBox(height: 12),
              _buildField(
                _imageUrlController,
                'Image URL (optional)',
                Icons.image,
                isRequired: false,
              ),
              const SizedBox(height: 12),
              _buildField(
                _stockController,
                'Stock',
                Icons.inventory,
                keyboard: TextInputType.number,
                validator: _intValidator,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlobalVariables.secondaryColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Add Product',
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
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool isRequired = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator:
          validator ??
          (value) {
            if (isRequired && (value == null || value.trim().isEmpty)) {
              return '$label is required';
            }
            return null;
          },
    );
  }

  String? _numberValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Price is required';
    if (double.tryParse(value.trim()) == null) return 'Enter a valid number';
    return null;
  }

  String? _intValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Stock is required';
    if (int.tryParse(value.trim()) == null) return 'Enter a valid whole number';
    return null;
  }
}
