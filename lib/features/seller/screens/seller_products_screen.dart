import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/Models/product_model.dart';
import 'package:cartwala/Models/store_model.dart';
import 'package:cartwala/features/Product/services/product_service.dart';
import 'package:cartwala/features/Auth/services/api_helper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SellerProductsScreen extends StatefulWidget {
  final Store store;
  const SellerProductsScreen({super.key, required this.store});

  @override
  State<SellerProductsScreen> createState() => _SellerProductsScreenState();
}

class _SellerProductsScreenState extends State<SellerProductsScreen> {
  List<Product> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _loading = true);
    try {
      final headers = await authHeaders();
      final res = await http.get(
        Uri.parse('$kBaseUrl/api/products/mine'),
        headers: headers,
      );
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        _products = list.map((e) => Product.fromJson(e)).toList();
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _deleteProduct(String id) async {
    try {
      await ProductService.deleteProduct(id);
      _loadProducts();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Products',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showAddProductSheet(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Add',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lime,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Product list
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.lime),
                  )
                : _products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No products yet',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tap "Add" to list your first product',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    color: AppColors.lime,
                    onRefresh: _loadProducts,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: _products.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _productTile(_products[i]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _productTile(Product product) {
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: product.imageUrl.isNotEmpty
              ? Image.network(
                  product.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                )
              : _placeholder(),
        ),
        title: Text(
          product.name,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          'Rs ${product.price.toStringAsFixed(0)} · Stock: ${product.stock}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: AppColors.error),
          onPressed: () {
            if (product.id != null) _deleteProduct(product.id!);
          },
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.image_outlined, color: AppColors.textHint),
    );
  }

  void _showAddProductSheet(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameC = TextEditingController();
    final descC = TextEditingController();
    final priceC = TextEditingController();
    final catC = TextEditingController();
    final imgC = TextEditingController();
    final stockC = TextEditingController();
    bool loading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColors.divider,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Add New Product',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _sheetField(nameC, 'Product Name', Icons.shopping_bag),
                      const SizedBox(height: 12),
                      _sheetField(
                        descC,
                        'Description',
                        Icons.description,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      _sheetField(
                        priceC,
                        'Price (Rs)',
                        Icons.currency_rupee,
                        keyboard: TextInputType.number,
                      ),
                      const SizedBox(height: 12),
                      _sheetField(catC, 'Category', Icons.category),
                      const SizedBox(height: 12),
                      _sheetField(
                        imgC,
                        'Image URL',
                        Icons.image,
                        required_: false,
                      ),
                      const SizedBox(height: 12),
                      _sheetField(
                        stockC,
                        'Stock',
                        Icons.inventory,
                        keyboard: TextInputType.number,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;
                                  setSheetState(() => loading = true);
                                  try {
                                    final product = Product(
                                      name: nameC.text.trim(),
                                      description: descC.text.trim(),
                                      price: double.parse(priceC.text.trim()),
                                      category: catC.text.trim(),
                                      imageUrl: imgC.text.trim(),
                                      stock: int.parse(stockC.text.trim()),
                                    );
                                    // Use auth headers for seller product creation
                                    final headers = await authHeaders();
                                    final res = await http.post(
                                      Uri.parse('$kBaseUrl/api/createproduct'),
                                      headers: headers,
                                      body: jsonEncode(product.toJson()),
                                    );
                                    if (res.statusCode == 201) {
                                      Navigator.pop(ctx);
                                      _loadProducts();
                                    } else {
                                      throw Exception('Failed');
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  } finally {
                                    setSheetState(() => loading = false);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lime,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: loading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.black,
                                  ),
                                )
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
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _sheetField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
    bool required_ = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.textSecondary,
        ),
        prefixIcon: Icon(icon, color: AppColors.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lime, width: 2),
        ),
      ),
      validator: required_
          ? (v) => (v == null || v.trim().isEmpty) ? '$label is required' : null
          : null,
    );
  }
}
