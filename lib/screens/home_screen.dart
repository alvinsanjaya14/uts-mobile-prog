import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              spacing: 24,
              children: [
                _buildSearchAndLocationBar(),
                _buildCategories(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: controller.loadProducts,
                    child: controller.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : controller.error != null
                        ? Center(child: Text(controller.error!))
                        : SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Column(
                                spacing: 20,
                                children: [
                                  Row(
                                    spacing: 12,
                                    children: const [
                                      Text(
                                        'Pick today',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Pick tomorrow',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  _buildDealsSection(
                                    context,
                                    controller.products,
                                  ),
                                  _buildPointsBanner(),
                                  _buildExpiringSoonSection(context),
                                  _buildPopularItemsSection(context),
                                  _buildPromoCard(),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 0,
            selectedItemColor: Colors.green[700],
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Saved',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Browse',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                label: 'Cart',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  // Already on home screen
                  break;
                case 1:
                  // Navigate to saved screen
                  context.goNamed('saved');
                  break;
                case 2:
                  // Browse - placeholder for future implementation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Browse feature coming soon!'),
                    ),
                  );
                  break;
                case 3:
                  // Cart - placeholder for future implementation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cart feature coming soon!')),
                  );
                  break;
                case 4:
                  context.goNamed('profile');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile feature coming soon!'),
                    ),
                  );
                  break;
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchAndLocationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Search', style: TextStyle(color: Colors.grey)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 6),
                Text('48 N 5th St - 2mi', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          const SizedBox(width: 6),
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
    );
  }

  Widget _buildDealsSection(BuildContext context, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deals near you',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...products.map(
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

  Widget _buildExpiringSoonSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expiring soon',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              StaticProductCard(
                title: 'Alcapurrias',
                price: '\$6.99',
                isSmall: true,
              ),
              const SizedBox(width: 12),
              StaticProductCard(
                title: 'Carrot–Harissa',
                price: '\$4.99',
                isSmall: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPopularItemsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Popular items',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              StaticProductCard(
                title: 'Fried rice',
                price: '\$2.99',
                isSmall: true,
              ),
              const SizedBox(width: 12),
              StaticProductCard(
                title: 'Rice desert',
                price: '\$2.99',
                isSmall: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Grab Happiness by the Bite!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your Ultimate Happy Hour Meal App for Delicious Deals!',
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: null,
                    child: Text('Get Started now'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.green[200],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0AA67B), Color(0xFF39BFA0)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '1100 points',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text(
                  'View history',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const LinearProgressIndicator(
            value: 0.55,
            color: Colors.white,
            backgroundColor: Colors.white24,
          ),
          const SizedBox(height: 8),
          const Text(
            'Get a free meal when you collect 2000 points.',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label),
    );
  }
}
