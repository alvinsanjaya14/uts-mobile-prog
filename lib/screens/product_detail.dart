import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product['product'];
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Custom app bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: product['imageurl'] != null
                      ? DecorationImage(
                          image: NetworkImage(product['imageurl']),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: product['imageurl'] == null ? Colors.grey[200] : null,
                ),
                child: product['imageurl'] == null
                    ? const Center(
                        child: Icon(
                          Icons.image,
                          size: 80,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
            ),
          ),

          // Product details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name and price
                  Text(
                    product['name'] ?? 'Product Name',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product['price']?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${product['rating']?.toStringAsFixed(1) ?? '0.0'}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product['rating_count'] ?? 0}+)',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Pickup time and location
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        product['availability'] ?? 'Pick up 1:00 PM - 3:00 PM',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Today',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          product['location'] ?? '23 Spruce Street, Portland, OR 97214',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // What you get section
                  const Text(
                    'What you get',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getProductDescription(product),
                    style: const TextStyle(
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ingredients section
                  _buildExpandableSection(
                    'Ingredients',
                    product['ingredients'],
                    _buildIngredientsContent,
                  ),
                  const SizedBox(height: 16),

                  // Allergens section
                  _buildExpandableSection(
                    'Allergens',
                    product['allergens'],
                    _buildAllergensContent,
                  ),
                  const SizedBox(height: 16),

                  // About Restaurant section
                  _buildExpandableSection(
                    'About Restaurant',
                    {'name': 'La Palapa Alegre'},
                    _buildRestaurantContent,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // Bottom reservation section
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Quantity selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                      icon: const Icon(Icons.remove),
                      color: quantity > 1 ? Colors.black : Colors.grey,
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => quantity++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Reserve button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle reservation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Reserved $quantity item(s)'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Reserve now',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildExpandableSection(
    String title,
    dynamic data,
    Widget Function(dynamic) contentBuilder,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.add),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: contentBuilder(data),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsContent(dynamic ingredients) {
    if (ingredients == null || ingredients is! List) {
      return const Text(
        'No ingredients information available.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients.map<Widget>((ingredient) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  ingredient['name'] ?? 'Unknown ingredient',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                '${ingredient['qty'] ?? ''} ${ingredient['unit'] ?? ''}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAllergensContent(dynamic allergens) {
    if (allergens == null || allergens is! List) {
      return const Text(
        'No allergen information available.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allergens.map<Widget>((allergen) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.orange[200]!),
          ),
          child: Text(
            allergen.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange[800],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRestaurantContent(dynamic restaurant) {
    return Row(
      children: [
        const Icon(Icons.restaurant, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            restaurant['name'] ?? 'Restaurant Name',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  String _getProductDescription(Map<String, dynamic> product) {
    // Generate description based on ingredients or provide default
    if (product['ingredients'] != null && product['ingredients'] is List) {
      final ingredients = product['ingredients'] as List;
      if (ingredients.isNotEmpty) {
        final mainIngredients = ingredients
            .take(3)
            .map((ing) => ing['name'])
            .where((name) => name != null)
            .join(', ');
        
        return 'Delicious ${product['name']?.toLowerCase() ?? 'dish'} made with $mainIngredients and served with various toppings.';
      }
    }
    
    return 'A delicious meal prepared with fresh ingredients and served with care.';
  }
}
