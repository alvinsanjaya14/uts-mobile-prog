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
        imageUrl: 'https://i0.wp.com/www.cosiitaliano.com/wp-content/uploads/2015/02/Vitello-Tonnato-Enhanced-680-x-455-June-2016.jpg?fit=680%2C455&ssl=1',
        rating: 4.5,
        ratingCount: 124,
        isAvailable: true,
        ingredients: [
          {'name': 'Veal'},
          {'name': 'Tuna'},
          {'name': 'Capers'},
          {'name': 'Mayonnaise'},
          {'name': 'Lemon juice'},
          {'name': 'Olive oil'},
        ],
        allergens: [
          {'name': 'Fish', 'severity': 'high'},
          {'name': 'Eggs', 'severity': 'medium'},
        ],
        restaurantId: 1,
      ),
      Product(
        id: '2',
        name: 'Pastelón',
        description: 'Sweet plantain, beef, and cheese casserole.',
        price: 5.99,
        imageUrl: 'https://www.simplyrecipes.com/thmb/ehXCegQJRbeCSTOv--lR4rfMung=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/__opt__aboutcom__coeus__resources__content_migration__simply_recipes__uploads__2018__03__Pastelon-Puerto-Rican-Lasagna-19-2589404285a248cb9a9be0a0bdc2890f.jpg',
        rating: 4.2,
        ratingCount: 87,
        isAvailable: true,
        ingredients: [
          {'name': 'Sweet plantains'},
          {'name': 'Ground beef'},
          {'name': 'Cheese'},
          {'name': 'Onions'},
          {'name': 'Garlic'},
          {'name': 'Bell peppers'},
          {'name': 'Tomato sauce'},
          {'name': 'Eggs'},
        ],
        allergens: [
          {'name': 'Dairy', 'severity': 'high'},
          {'name': 'Eggs', 'severity': 'medium'},
        ],
        restaurantId: 1,
      ),
    ];
  }

  Future<Product> fetchProductById(String id) async {
    final products = await fetchProducts();
    return products.firstWhere((p) => p.id == id);
  }
}