import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../widgets/bottom_navbar.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Load saved products when home screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().loadSavedProducts();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Full width banner at the top
              _buildBannerCarousel(),
              // Rest of the content with SafeArea
              Expanded(
                child: SafeArea(
                  top: false, // Banner already at top
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
                                  const SizedBox(),
                                  _buildPointsBanner(),
                                  _buildActionButtons(context),
                                  _buildMenuSection(context, controller),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const BottomNavbar(currentIndex: 0),
        );
      },
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

  Widget _buildBannerCarousel() {
    return Stack(
      children: [
        SizedBox(
          height:
              250 + MediaQuery.of(context).padding.top, // Add status bar height
          width: double.infinity,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            children: [
              _buildBannerItem(
                'Special Offer',
                'Get 20% off on all items',
                'assets/banner1.jpg',
              ),
              _buildBannerItem(
                'New Menu',
                'Try our latest dishes',
                'assets/banner2.png',
              ),
              _buildBannerItem(
                'Happy Hour',
                'Enjoy discounts from 3-6 PM',
                'assets/banner3.jpg',
              ),
            ],
          ),
        ),
        // Page indicators positioned at the bottom of the banner
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentBannerIndex
                      ? Colors.white
                      : Colors.white54,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(String title, String subtitle, String imageUrl) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback gradient if image fails to load
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0AA67B), Color(0xFF39BFA0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                );
              },
            ),
          ),
          // Dark overlay for better text readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.1),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          // Content overlay
          Positioned(
            bottom: 40, // More space from bottom to account for indicators
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.shopping_cart,
            label: 'Order Now',
            onTap: () {
              context.goNamed('browse');
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            icon: Icons.event_seat,
            label: 'Reserve',
            onTap: () {
              context.goNamed('browse');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0AA67B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, ProductController controller) {
    // Check if user has saved products
    final hasSavedProducts = controller.savedProducts.isNotEmpty;

    if (hasSavedProducts) {
      // Show saved products
      return _buildSavedMenuSection(context, controller.savedProducts);
    } else {
      // Show popular menu as fallback
      return _buildPopularMenuSection(context, controller.products);
    }
  }

  Widget _buildSavedMenuSection(
    BuildContext context,
    List<Product> savedProducts,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Saved Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                context.goNamed('saved');
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: const Color(0xFF0AA67B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...savedProducts
                  .take(4)
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

  Widget _buildPopularMenuSection(
    BuildContext context,
    List<Product> products,
  ) {
    // Get top-rated products (4.5+ rating) sorted by rating count for popularity
    final popularProducts =
        products
            .where((product) => product.rating >= 4.0 && product.isAvailable)
            .toList()
          ..sort((a, b) => b.ratingCount.compareTo(a.ratingCount));

    final topPopular = popularProducts.take(4).toList();

    if (topPopular.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Menu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                context.goNamed('browse');
              },
              child: Text(
                'Browse All',
                style: TextStyle(
                  color: const Color(0xFF0AA67B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...topPopular.map(
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
