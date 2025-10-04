import 'package:flutter/material.dart';
import 'package:uts_mobile_restoran/widgets/custom_button.dart';
import '../models/product.dart';

/// Product detail view (MVC View) replicating original `ProductDetailScreen` layout.
/// Missing domain fields (rating, availability, location, ingredients, allergens) are
/// currently shown with placeholder / derived values since `Product` model
/// does not yet expose them. Extend `Product` or introduce a separate detail
/// DTO if backend adds those fields.
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;

  // Placeholder mock data (would come from a service in a fuller implementation)
  double get _rating => 4.8; // TODO: replace with real field
  int get _ratingCount => 120; // TODO: replace with real field
  String get _availability => 'Pick up 1:00 PM - 3:00 PM';
  String get _location => '23 Spruce Street, Portland, OR 97214';
  List<Map<String, dynamic>> get _ingredients => const [
    {'name': 'Tomato', 'qty': 2, 'unit': 'pcs'},
    {'name': 'Basil', 'qty': 5, 'unit': 'leaves'},
    {'name': 'Olive Oil', 'qty': 10, 'unit': 'ml'},
  ];
  List<String> get _allergens => const ['Dairy', 'Gluten'];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: _circleIconButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              _circleIconButton(icon: Icons.favorite_border, onPressed: () {}),
              _circleIconButton(icon: Icons.share, onPressed: () {}),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  image: product.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(product.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: product.imageUrl == null ? Colors.grey[200] : null,
                ),
                child: product.imageUrl == null
                    ? const Center(
                        child: Icon(Icons.image, size: 80, color: Colors.grey),
                      )
                    : null,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Rating row
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        _rating.toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($_ratingCount+)',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Availability + day
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _availability,
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
                      const Text('Today', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _location,
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'What you get',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getProductDescription(product),
                    style: const TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  _buildExpandableSection(
                    'Ingredients',
                    _ingredients,
                    _buildIngredientsContent,
                  ),
                  const SizedBox(height: 16),
                  _buildExpandableSection(
                    'Allergens',
                    _allergens,
                    _buildAllergensContent,
                  ),
                  const SizedBox(height: 16),
                  _buildExpandableSection('About Restaurant', {
                    'name': 'Italiano Ristorante',
                  }, _buildRestaurantContent),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom reservation bar replicating original behavior
      bottomSheet: _buildBottomReservation(product),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
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
        icon: Icon(icon, color: Colors.black),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildBottomReservation(Product product) {
    return Container(
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
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: quantity > 1
                        ? () => setState(() => quantity--)
                        : null,
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
            Expanded(
              child: CustomButton.primary(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reserved $quantity item(s)'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                text: 'Reserve now',
              ),
            ),
          ],
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                style: const TextStyle(fontSize: 14, color: Colors.grey),
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
            style: TextStyle(fontSize: 12, color: Colors.orange[800]),
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

  String _getProductDescription(Product product) {
    // Placeholder description generation using mock ingredients list.
    if (_ingredients.isNotEmpty) {
      final main = _ingredients
          .take(3)
          .map((e) => e['name'])
          .whereType<String>()
          .join(', ');
      return 'Delicious ${product.name.toLowerCase()} made with $main and served with various toppings.';
    }
    return 'A delicious meal prepared with fresh ingredients and served with care.';
  }
}
