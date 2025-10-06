import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
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
        imageUrl: 'assets/vitello.jpg',
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
      ),
      Product(
        id: '2',
        name: 'Pastelón',
        description: 'Sweet plantain, beef, and cheese casserole.',
        price: 5.99,
        imageUrl: 'assets/pastelon.jpg',
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
      ),
      Product(
        id: '3',
        name: 'Chicken Tikka Masala',
        description: 'Creamy tomato-based curry with tender chicken pieces.',
        price: 8.99,
        imageUrl: 'assets/chicken.webp',
        rating: 4.7,
        ratingCount: 203,
        isAvailable: true,
        ingredients: [
          {'name': 'Chicken breast'},
          {'name': 'Yogurt'},
          {'name': 'Tomatoes'},
          {'name': 'Heavy cream'},
          {'name': 'Garam masala'},
          {'name': 'Ginger'},
          {'name': 'Garlic'},
          {'name': 'Onions'},
        ],
        allergens: [
          {'name': 'Dairy', 'severity': 'high'},
        ],
      ),
      Product(
        id: '4',
        name: 'Pad Thai',
        description: 'Stir-fried rice noodles with shrimp, tofu, and peanuts.',
        price: 7.49,
        imageUrl: 'assets/chicken-padthai.jpg',
        rating: 4.3,
        ratingCount: 156,
        isAvailable: true,
        ingredients: [
          {'name': 'Rice noodles'},
          {'name': 'Shrimp'},
          {'name': 'Tofu'},
          {'name': 'Bean sprouts'},
          {'name': 'Peanuts'},
          {'name': 'Tamarind paste'},
          {'name': 'Fish sauce'},
          {'name': 'Eggs'},
        ],
        allergens: [
          {'name': 'Shellfish', 'severity': 'high'},
          {'name': 'Peanuts', 'severity': 'high'},
          {'name': 'Eggs', 'severity': 'medium'},
          {'name': 'Fish', 'severity': 'medium'},
        ],
      ),
      Product(
        id: '5',
        name: 'Beef Tacos',
        description: 'Three soft-shell tacos with seasoned ground beef.',
        price: 4.99,
        imageUrl: 'assets/beef-tacos.webp',
        rating: 4.1,
        ratingCount: 98,
        isAvailable: true,
        ingredients: [
          {'name': 'Ground beef'},
          {'name': 'Flour tortillas'},
          {'name': 'Lettuce'},
          {'name': 'Tomatoes'},
          {'name': 'Cheese'},
          {'name': 'Sour cream'},
          {'name': 'Onions'},
          {'name': 'Cilantro'},
        ],
        allergens: [
          {'name': 'Dairy', 'severity': 'medium'},
          {'name': 'Gluten', 'severity': 'medium'},
        ],
      ),
      Product(
        id: '6',
        name: 'Caesar Salad',
        description: 'Crisp romaine lettuce with parmesan and croutons.',
        price: 3.99,
        imageUrl: 'assets/caesar.jpg',
        rating: 3.8,
        ratingCount: 67,
        isAvailable: true,
        ingredients: [
          {'name': 'Romaine lettuce'},
          {'name': 'Parmesan cheese'},
          {'name': 'Croutons'},
          {'name': 'Caesar dressing'},
          {'name': 'Anchovies'},
          {'name': 'Lemon juice'},
        ],
        allergens: [
          {'name': 'Dairy', 'severity': 'high'},
          {'name': 'Fish', 'severity': 'medium'},
          {'name': 'Gluten', 'severity': 'medium'},
        ],
      ),
      Product(
        id: '7',
        name: 'Sushi Combo',
        description: 'Fresh assorted sushi rolls with wasabi and ginger.',
        price: 12.99,
        imageUrl: 'assets/sushi.jpg',
        rating: 4.8,
        ratingCount: 245,
        isAvailable: true,
        ingredients: [
          {'name': 'Sushi rice'},
          {'name': 'Fresh salmon'},
          {'name': 'Tuna'},
          {'name': 'Nori'},
          {'name': 'Cucumber'},
          {'name': 'Avocado'},
          {'name': 'Wasabi'},
          {'name': 'Pickled ginger'},
        ],
        allergens: [
          {'name': 'Fish', 'severity': 'high'},
        ],
      ),
      Product(
        id: '8',
        name: 'Margherita Pizza',
        description: 'Classic pizza with fresh mozzarella, tomato, and basil.',
        price: 9.49,
        imageUrl: 'assets/margherita-pizza.webp',
        rating: 4.4,
        ratingCount: 178,
        isAvailable: true,
        ingredients: [
          {'name': 'Pizza dough'},
          {'name': 'Fresh mozzarella'},
          {'name': 'Tomato sauce'},
          {'name': 'Fresh basil'},
          {'name': 'Olive oil'},
          {'name': 'Garlic'},
        ],
        allergens: [
          {'name': 'Dairy', 'severity': 'high'},
          {'name': 'Gluten', 'severity': 'high'},
        ],
      ),
      Product(
        id: '9',
        name: 'Greek Gyros',
        description: 'Lamb and beef gyros with tzatziki and vegetables.',
        price: 6.79,
        imageUrl: 'assets/greek-gyros.webp',
        rating: 4.6,
        ratingCount: 134,
        isAvailable: true,
        ingredients: [
          {'name': 'Lamb'},
          {'name': 'Beef'},
          {'name': 'Pita bread'},
          {'name': 'Tzatziki sauce'},
          {'name': 'Tomatoes'},
          {'name': 'Red onions'},
          {'name': 'Cucumber'},
          {'name': 'Feta cheese'},
        ],
        allergens: [
          {'name': 'Dairy', 'severity': 'high'},
          {'name': 'Gluten', 'severity': 'medium'},
        ],
      ),
    ];
  }

  Future<Product> fetchProductById(String id) async {
    final products = await fetchProducts();
    return products.firstWhere((p) => p.id == id);
  }

  /// Fetches saved product IDs from SharedPreferences
  Future<List<String>> fetchSavedProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('saved_product_ids') ?? [];
    return savedIds;
  }

  /// Saves a product ID to favorites
  Future<bool> saveProductToFavorites(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('saved_product_ids') ?? [];
    
    if (!savedIds.contains(productId)) {
      savedIds.add(productId);
      return await prefs.setStringList('saved_product_ids', savedIds);
    }
    return true; // Already saved
  }

  /// Removes a product ID from favorites
  Future<bool> removeProductFromFavorites(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('saved_product_ids') ?? [];
    
    if (savedIds.contains(productId)) {
      savedIds.remove(productId);
      return await prefs.setStringList('saved_product_ids', savedIds);
    }
    return true; // Already removed
  }

  /// Checks if a product is saved to favorites
  Future<bool> isProductSaved(String productId) async {
    final savedIds = await fetchSavedProductIds();
    return savedIds.contains(productId);
  }

  /// Fetches full product details for saved product IDs
  Future<List<Product>> fetchSavedProducts() async {
    final savedIds = await fetchSavedProductIds();
    final allProducts = await fetchProducts();
    
    // Filter products by saved IDs
    return allProducts.where((product) => savedIds.contains(product.id)).toList();
  }

  /// Searches products by keyword (name, description, ingredients)
  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) {
      return await fetchProducts();
    }

    final allProducts = await fetchProducts();
    final searchQuery = query.toLowerCase();
    
    return allProducts.where((product) {
      final name = product.name.toLowerCase();
      return name.contains(searchQuery);
    }).toList();
  }
}