import 'package:flutter/material.dart';
import 'package:cartwala/GlobalVariables.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final double productPrice;
  final double rating;
  final double discountPercentage;
  const ProductCard({
    super.key,
    this.imageUrl = "",
    required this.productName,
    this.rating = 0.0,
    this.discountPercentage = 0.0,
    required this.productPrice,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String get _imageUrl {
    final url = widget.imageUrl.trim();
    if (url.isEmpty) return _placeholder;
    return url;
  }

  String get _placeholder =>
      'https://picsum.photos/seed/${Uri.encodeComponent(widget.productName)}/400/300';

  @override
  Widget build(BuildContext context) {
    final hasDiscount = widget.discountPercentage > 0;
    final hasRating = widget.rating > 0;

    return Card(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image section ─────────────────────────────────────
          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  _imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppColors.background,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.lime,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      _placeholder,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.background,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 40,
                          color: AppColors.textHint,
                        ),
                      ),
                    );
                  },
                ),

                // Discount badge
                if (hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lime,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '-${widget.discountPercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.headerDark,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Content section ───────────────────────────────────
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Product name
                  Text(
                    widget.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                      height: 1.25,
                    ),
                  ),

                  // Price + Rating row
                  Row(
                    children: [
                      Text(
                        '₹${widget.productPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.limeDark,
                        ),
                      ),
                      const Spacer(),
                      if (hasRating) ...[
                        Icon(
                          Icons.star_rounded,
                          size: 15,
                          color: AppColors.starColor,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          widget.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
