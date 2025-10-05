import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/product_card.dart';
import '../models/product.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _selectedCategory = '';

  @override
  void initState() {
    super.initState();
    // Load products when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().loadProducts();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = ''; // Deselect if already selected
      } else {
        _selectedCategory = category;
      }
    });
  }

  List<Product> _filterProducts(List<Product> products) {
    List<Product> filteredProducts = products;

    // Apply category filter
    if (_selectedCategory.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        final name = product.name.toLowerCase();
        final description = product.description.toLowerCase();

        switch (_selectedCategory.toLowerCase()) {
          case 'italian':
            return name.contains('vitello') ||
                name.contains('pizza') ||
                description.contains('italian');
          case 'mexican':
            return name.contains('taco') || description.contains('mexican');
          case 'indian':
            return name.contains('tikka') ||
                name.contains('masala') ||
                description.contains('curry') ||
                description.contains('indian');
          case 'lebanese':
            return name.contains('gyros') || description.contains('lebanese');
          default:
            return true;
        }
      }).toList();
    }

    return filteredProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Browse',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                context.goNamed('search');
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Text(
                      'Search for dishes, ingredients...',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Filter Categories
          _buildCategories(),

          // Products List
          Expanded(
            child: Consumer<ProductController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading products',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.error!,
                          style: TextStyle(color: Colors.grey.shade500),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.loadProducts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final filteredProducts = _filterProducts(controller.products);

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedCategory.isEmpty
                              ? Icons.restaurant_menu
                              : Icons.category,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCategory.isEmpty
                              ? 'No products available'
                              : 'No $_selectedCategory products found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (_selectedCategory.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Try selecting a different category',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => controller.loadProducts(),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Today's Deals Section (only show when no category filter)
                        if (_selectedCategory.isEmpty) ...[
                          _buildDealsSection(context, controller.products),
                          const SizedBox(height: 24),
                        ],

                        // Popular Items Section (only show when no category filter)
                        if (_selectedCategory.isEmpty) ...[
                          _buildPopularItemsSection(
                            context,
                            controller.products,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Category Results Header
                        if (_selectedCategory.isNotEmpty) ...[
                          Text(
                            'Category: $_selectedCategory (${filteredProducts.length})',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // All Products Title (when no category filter)
                        if (_selectedCategory.isEmpty) ...[
                          const Text(
                            'All Products',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Products Grid
                        ...filteredProducts.map(
                          (product) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ProductCard(
                              product: product,
                              isSmall: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavbar(currentIndex: 2),
    );
  }

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildCategoryButton(Icons.filter_list, 'Filters'),
            const SizedBox(width: 8),
            _buildCategoryChip('Italian'),
            const SizedBox(width: 8),
            _buildCategoryChip('Mexican'),
            const SizedBox(width: 8),
            _buildCategoryChip('Indian'),
            const SizedBox(width: 8),
            _buildCategoryChip('Lebanese'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.green, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;

    return GestureDetector(
      onTap: () => _onCategorySelected(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[100] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Colors.green, width: 1.5)
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.green[700] : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  Widget _buildDealsSection(BuildContext context, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Deals',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...products
                  .take(5)
                  .map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ProductCard(product: p),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularItemsSection(
    BuildContext context,
    List<Product> products,
  ) {
    // Get top 5 products by rating count
    final popularProducts = List<Product>.from(products)
      ..sort((a, b) => b.ratingCount.compareTo(a.ratingCount))
      ..take(5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...popularProducts
                  .take(5)
                  .map(
                    (product) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ProductCard(product: product, isSmall: true),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
