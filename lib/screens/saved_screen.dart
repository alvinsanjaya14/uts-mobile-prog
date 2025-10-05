import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card.dart';
import '../widgets/bottom_navbar.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    // Load saved products when screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductController>().loadSavedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Saved Products',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: controller.loadSavedProducts,
            child: controller.isSavedLoading
                ? const Center(child: CircularProgressIndicator())
                : controller.savedError != null
                    ? _buildErrorState(controller.savedError!)
                    : controller.savedProducts.isEmpty
                        ? _buildEmptyState()
                        : _buildSavedProductsList(controller),
          ),
          bottomNavigationBar: const BottomNavbar(currentIndex: 1),
        );
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading saved products',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductController>().loadSavedProducts();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 0, 127, 95),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bookmark_border,
                  size: 48,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'You don\'t have anything saved',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Save your favorite items by tapping the\nheart icon on any product',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  context.goNamed('browse');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 127, 95),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Start browsing',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedProductsList(ProductController controller) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Text(
              '${controller.savedProducts.length} saved ${controller.savedProducts.length == 1 ? 'product' : 'products'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _buildListView(controller),
        ],
      ),
    );
  }

  Widget _buildListView(ProductController controller) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.savedProducts.length,
      itemBuilder: (context, index) {
        final product = controller.savedProducts[index];
        // Simulate some sample data for demonstration
        final stockCounts = [3, 8, 1, 12, 5, 2, 15];
        
        return ProductRowCard(
          product: product,
          stockCount: stockCounts[index % stockCounts.length],
          isFavorite: true, // Since these are saved products
          onFavoriteToggle: () async {
            // Remove from favorites using the controller
            await context.read<ProductController>().toggleProductSaved(product);
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} removed from saved items'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.grey[800],
                ),
              );
            }
          },
        );
      },
    );
  }
}