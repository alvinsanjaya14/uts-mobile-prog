import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/cart_controller.dart'; // <-- Pastikan ini ada
import '../routes.dart'; 
import 'package:uts_mobile_restoran/widgets/circle_icon_button.dart';
import 'package:uts_mobile_restoran/widgets/custom_button.dart';
import '../models/product.dart';
import '../models/restaurant.dart';
import '../controllers/restaurant_controller.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  Restaurant? _restaurant;

  // Track expansion states
  bool _ingredientsExpanded = false;
  bool _allergensExpanded = false;

  // Use actual product model data
  double get _rating => widget.product.rating;
  int get _ratingCount => widget.product.ratingCount;
  List<Map<String, dynamic>> get _ingredients => widget.product.ingredients;
  List<Map<String, dynamic>> get _allergens => widget.product.allergens;

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

  Future<void> _loadRestaurant() async {
    final controller = context.read<RestaurantController>();
    final restaurant = await controller.getRestaurantById(
      widget.product.restaurantId.toString(),
    );
    if (restaurant != null && mounted) {
      setState(() {
        _restaurant = restaurant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: CircleIconButton.transparent(
              iconColor: Colors.white,
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              CircleIconButton.filled(
                icon: Icons.favorite_border,
                onPressed: () {},
              ),
              CircleIconButton.filled(icon: Icons.share, onPressed: () {}),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ],
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
                  if (_restaurant != null) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Pick up ${_restaurant!.pickUpSchedule.scheduleText}',
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
                        Text(
                          _restaurant!.pickUpSchedule.isOpenNow()
                              ? 'Open now'
                              : 'Closed',
                          style: TextStyle(
                            color: _restaurant!.pickUpSchedule.isOpenNow()
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  if (_restaurant != null) ...[
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
                            _restaurant!.address,
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'What you will get',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : _getProductDescription(product),
                    style: const TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  _buildExpandableSection(
                    'Ingredients',
                    _ingredients,
                    _buildIngredientsContent,
                    _ingredientsExpanded,
                    (expanded) =>
                        setState(() => _ingredientsExpanded = expanded),
                  ),
                  const SizedBox(height: 16),
                  _buildExpandableSection(
                    'Allergens',
                    _allergens,
                    _buildAllergensContent,
                    _allergensExpanded,
                    (expanded) => setState(() => _allergensExpanded = expanded),
                  ),
                  const SizedBox(height: 16),
                  if (_restaurant != null) ...[
                    const Text(
                      'About Restaurant',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildRestaurantContent(_restaurant),
                  ],
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
                // <-- GANTI LOGIKA DI SINI
                final cartController = context.read<CartController>();
                cartController.addItem(product, quantity);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added $quantity x ${product.name} to cart'),
                    backgroundColor: Colors.green,
                    action: SnackBarAction(
                      label: 'VIEW CART',
                      textColor: Colors.white,
                      onPressed: () {
                        context.go(AppRoutes.cart);
                      },
                    ),
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
    bool isExpanded,
    Function(bool) onExpansionChanged,
  ) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      trailing: Icon(isExpanded ? Icons.remove : Icons.add),
      shape: const Border(),
      collapsedShape: const Border(),
      onExpansionChanged: onExpansionChanged,
      children: [
        Padding(padding: const EdgeInsets.all(16), child: contentBuilder(data)),
      ],
    );
  }

  Widget _buildIngredientsContent(dynamic ingredients) {
    if (ingredients == null || ingredients is! List || ingredients.isEmpty) {
      return const Text(
        'No ingredients information available.',
        style: TextStyle(color: Colors.grey),
      );
    }
    
    final ingredientNames = ingredients.map((ingredient) {
      if (ingredient is Map<String, dynamic>) {
        return ingredient['name'] ?? 'Unknown ingredient';
      } else {
        return ingredient.toString();
      }
    }).toList();
    
    return Text(
      ingredientNames.join(', '),
      style: const TextStyle(fontSize: 14),
    );
  }

  Widget _buildAllergensContent(dynamic allergens) {
    if (allergens == null || allergens is! List || allergens.isEmpty) {
      return const Text(
        'No allergen information available.',
        style: TextStyle(color: Colors.grey),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: allergens.map<Widget>((allergen) {
        String allergenName;

        if (allergen is Map<String, dynamic>) {
          allergenName = allergen['name'] ?? 'Unknown';
        } else {
          allergenName = allergen.toString();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              const Icon(
                Icons.warning_amber_outlined,
                size: 16,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(allergenName, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRestaurantContent(dynamic restaurant) {
    if (restaurant is! Restaurant) {
      return const Text(
        'Restaurant information not available.',
        style: TextStyle(color: Colors.grey),
      );
    }

    return InkWell(
      onTap: () => _showRestaurantBottomSheet(restaurant),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            const Icon(Icons.store, color: Colors.grey, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                restaurant.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showRestaurantBottomSheet(Restaurant restaurant) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Restaurant image
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: restaurant.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(restaurant.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: restaurant.imageUrl == null 
                            ? Colors.grey[200] 
                            : null,
                      ),
                      child: restaurant.imageUrl == null
                          ? const Center(
                              child: Icon(
                                Icons.restaurant,
                                size: 60,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Restaurant name
                    Text(
                      restaurant.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Rating and pickup time row
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${restaurant.rating.toStringAsFixed(1)} (${restaurant.ratingCount}+)',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.pickUpSchedule.scheduleText,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    // Location and directions row
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            restaurant.address,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 8),
                        CustomButton.primary(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Opening directions...'),
                                backgroundColor: Colors.blue,
                              ),
                            );
                          },
                          text: 'Directions',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Products section
                    const Text(
                      'Menu Items',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Product list
                    _buildRestaurantProductList(restaurant),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantProductList(Restaurant restaurant) {
    // Get products from this restaurant
    return FutureBuilder<List<Product>>(
      future: _getProductsByRestaurant(restaurant.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text(
            'No menu items available.',
            style: TextStyle(color: Colors.grey),
          );
        }
        
        final products = snapshot.data!;
        return Column(
          children: products.map((product) => 
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Product image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: product.imageUrl != null
                          ? DecorationImage(
                              image: NetworkImage(product.imageUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: product.imageUrl == null ? Colors.grey[200] : null,
                    ),
                    child: product.imageUrl == null
                        ? const Icon(Icons.fastfood, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  
                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        if (product.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            product.description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).toList(),
        );
      },
    );
  }

  Future<List<Product>> _getProductsByRestaurant(String restaurantId) async {
    // This is a mock implementation - in a real app, you'd fetch from your service
    // For now, return a filtered list based on the current product's restaurant
    if (restaurantId == widget.product.restaurantId.toString()) {
      return [widget.product]; // Return current product as example
    }
    return [];
  }

  String _getProductDescription(Product product) {
    // Generate description based on ingredients or provide default
    if (product.ingredients.isNotEmpty) {
      final mainIngredients = product.ingredients
          .take(3)
          .map((ing) => ing['name'])
          .where((name) => name != null)
          .join(', ');

      return 'Delicious ${product.name.toLowerCase()} made with $mainIngredients and served with various toppings.';
    }

    return 'A delicious meal prepared with fresh ingredients and served with care.';
  }
}
