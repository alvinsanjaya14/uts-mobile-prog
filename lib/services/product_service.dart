import 'dart:async';
import '../models/product.dart';

/// Simulated data service. Replace with real API / DB layer later.
class ProductService {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const [
      Product(
        id: '1',
        name: 'Vitello Tonnato',
        description: 'Classic Italian dish with tuna-caper sauce.',
        price: 6.99,
        imageUrl: null,
      ),
      Product(
        id: '2',
        name: 'Pastelón',
        description: 'Sweet plantain, beef, and cheese casserole.',
        price: 5.99,
        imageUrl: null,
      ),
    ];
  }

  Future<Product> fetchProductById(String id) async {
    final products = await fetchProducts();
    return products.firstWhere((p) => p.id == id);
  }
}
