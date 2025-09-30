import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import 'product_detail_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
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
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      // Pick today / tomorrow toggle (static for now)
                                      Row(
                                        children: const [
                                          Text(
                                            'Pick today',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 12),
                                          Text('Pick tomorrow', style: TextStyle(color: Colors.grey)),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Deals near you (dynamic via controller)
                                      _buildDealsSection(context, controller.products),
                                      const SizedBox(height: 16),
                                      _buildPointsBanner(),
                                      const SizedBox(height: 18),
                                      _buildExpiringSoonSection(context),
                                      const SizedBox(height: 18),
                                      _buildPopularItemsSection(context),
                                      const SizedBox(height: 18),
                                      _buildPromoCard(),
                                      const SizedBox(height: 80),
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
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Saved'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
            onTap: (i) {},
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
      height: 96,
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
        const Text('Deals near you', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...products.map((p) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: _buildDynamicFoodCard(context, p),
                  )),
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
        const Text('Expiring soon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildStaticFoodCard(context, 'Alcapurrias', '\$6.99', small: true),
              const SizedBox(width: 12),
              _buildStaticFoodCard(context, 'Carrot–Harissa', '\$4.99', small: true),
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
        const Text('Popular items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildStaticFoodCard(context, 'Fried rice', '\$2.99', small: true),
              const SizedBox(width: 12),
              _buildStaticFoodCard(context, 'Rice desert', '\$2.99', small: true),
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
                  Text('Grab Happiness by the Bite!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Your Ultimate Happy Hour Meal App for Delicious Deals!'),
                  SizedBox(height: 12),
                  ElevatedButton(onPressed: null, child: Text('Get Started now')),
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

  // Dynamic card for products coming from controller
  Widget _buildDynamicFoodCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailView(product: product),
          ),
        );
      },
      child: Container(
        width: 260,
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
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: product.imageUrl == null
                  ? const Center(child: Icon(Icons.image, size: 36, color: Colors.grey))
                  : ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: Image.network(product.imageUrl!, fit: BoxFit.cover),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      SizedBox(width: 6),
                      Text('08 - 10 pm', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(width: 8),
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 6),
                      Text('0.8 mi', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Static card pattern reused for Expiring soon / Popular items
  Widget _buildStaticFoodCard(BuildContext context, String title, String price, {bool small = false}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: small ? 160 : 260,
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: small ? 80 : 110,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Center(child: Icon(Icons.image, size: 36, color: Colors.grey)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(price, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Row(
                    children: const [
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      SizedBox(width: 6),
                      Text('08 - 10 pm', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(width: 8),
                      Icon(Icons.location_on, size: 14, color: Colors.grey),
                      SizedBox(width: 6),
                      Text('0.8 mi', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label),
    );
  }
}
