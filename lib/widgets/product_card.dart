import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../controllers/product_controller.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isSmall;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.isSmall = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _navigateToProduct(context),
      child: Container(
        width: isSmall ? 160 : MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            _buildProductInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: isSmall ? 80 : 110,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: product.imageUrl == null
          ? const Center(
              child: Icon(Icons.image, size: 36, color: Colors.grey),
            )
          : ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image, size: 36, color: Colors.grey),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (product.rating > 0) ...[
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: Colors.amber[600],
                ),
                const SizedBox(width: 2),
                Text(
                  product.rating.toStringAsFixed(1),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                if (product.ratingCount > 0) ...[
                  Text(
                    ' (${product.ratingCount})',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
          ],
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }


  void _navigateToProduct(BuildContext context) {
    final id = product.id.isNotEmpty 
        ? product.id 
        : product.name.hashCode.toString();
    context.push('/product/$id', extra: product);
  }
}

// Static product card for items without Product model data
class StaticProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String? imageUrl;
  final bool isSmall;
  final VoidCallback? onTap;

  const StaticProductCard({
    super.key,
    required this.title,
    required this.price,
    this.imageUrl,
    this.isSmall = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: isSmall ? 160 : 260,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStaticImage(),
            _buildStaticInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticImage() {
    return Container(
      height: isSmall ? 80 : 110,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: imageUrl == null
          ? const Center(
              child: Icon(Icons.image, size: 36, color: Colors.grey),
            )
          : ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image, size: 36, color: Colors.grey),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildStaticInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            price,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Horizontal row-style product card
class ProductRowCard extends StatefulWidget {
  final Product product;
  final int? stockCount;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool? isFavorite; // Make nullable for auto-detection

  const ProductRowCard({
    super.key,
    required this.product,
    this.stockCount,
    this.onTap,
    this.onFavoriteToggle,
    this.isFavorite, // Auto-detect if null
  });

  @override
  State<ProductRowCard> createState() => _ProductRowCardState();
}

class _ProductRowCardState extends State<ProductRowCard> {
  bool? _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    if (_isFavorite == null) {
      _checkIfSaved();
    }
  }

  Future<void> _checkIfSaved() async {
    if (mounted) {
      final isCurrentlySaved = await context.read<ProductController>().isProductSaved(widget.product.id);
      if (mounted) {
        setState(() {
          _isFavorite = isCurrentlySaved;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () => _navigateToProduct(context),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildProductImage(),
              const SizedBox(width: 12),
              Expanded(child: _buildProductInfo()),
              _buildTrailingSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: widget.product.imageUrl == null
          ? const Center(
              child: Icon(Icons.image, size: 24, color: Colors.grey),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.product.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(Icons.image, size: 24, color: Colors.grey),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.product.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '\$${widget.product.price.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color.fromARGB(255, 0, 127, 95),
          ),
        ),
        const SizedBox(height: 4),
        if (widget.product.rating > 0) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star,
                size: 14,
                color: Colors.amber[600],
              ),
              const SizedBox(width: 2),
              Text(
                widget.product.rating.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              if (widget.product.ratingCount > 0) ...[
                Text(
                  ' (${widget.product.ratingCount})',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTrailingSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () async {
            if (widget.onFavoriteToggle != null) {
              widget.onFavoriteToggle!();
            } else {
              // Handle favorite toggle ourselves
              await context.read<ProductController>().toggleProductSaved(widget.product);
              await _checkIfSaved(); // Refresh the saved state
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      (_isFavorite ?? false)
                        ? '${widget.product.name} added to saved items'
                        : '${widget.product.name} removed from saved items',
                    ),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.grey[800],
                  ),
                );
              }
            }
          },
          icon: Icon(
            (_isFavorite ?? false) ? Icons.favorite : Icons.favorite_border,
            color: (_isFavorite ?? false)
                ? Colors.red[400] 
                : Colors.grey[400],
            size: 24,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(
            minWidth: 32,
            minHeight: 32,
          ),
        ),
        const SizedBox(height: 8),
        if (widget.stockCount != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStockColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${widget.stockCount} left',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ] else if (!widget.product.isAvailable) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Unavailable',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getStockColor() {
    if (widget.stockCount == null) return Colors.grey;
    if (widget.stockCount! <= 2) return Colors.red[400]!;
    if (widget.stockCount! <= 5) return Colors.orange[400]!;
    return Colors.green[400]!;
  }

  void _navigateToProduct(BuildContext context) {
    final id = widget.product.id.isNotEmpty 
        ? widget.product.id 
        : widget.product.name.hashCode.toString();
    context.push('/product/$id', extra: widget.product);
  }
}