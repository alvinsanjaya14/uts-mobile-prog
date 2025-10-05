import 'dart:async';
import 'dart:convert';
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
      ),
      Product(
        id: '3',
        name: 'Chicken Tikka Masala',
        description: 'Creamy tomato-based curry with tender chicken pieces.',
        price: 8.99,
        imageUrl: 'https://www.recipetineats.com/wp-content/uploads/2018/04/Chicken-Tikka-Masala_1.jpg',
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
        imageUrl: 'https://www.recipetineats.com/wp-content/uploads/2020/01/Chicken-Pad-Thai_9.jpg',
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
        imageUrl: 'https://www.simplyrecipes.com/thmb/3BZr8MjBKy9Ll7K1CJZN8e3KfkE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Easy-Ground-Beef-Tacos-LEAD-2-64769e59d80140e29a48bb80266b86c9.jpg',
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
        imageUrl: 'https://www.simplyrecipes.com/thmb/CzCOgdG1nPs2cPNXMELCwgiqWBc=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Easy-Caesar-Salad-LEAD-03-0b2407fdf7db49d7820b8b07b1cb5d0d.jpg',
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
        imageUrl: 'https://www.justonecookbook.com/wp-content/uploads/2020/01/Sushi-Combo-4855-I.jpg',
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
        imageUrl: 'https://www.simplyrecipes.com/thmb/HhcUqkB7w_D6rW3J9aF7rKzm7iM=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Margherita-Pizza-LEAD-1-bc4a0c9a2dcc4eb8ab1e0c0c7bb9c4be.jpg',
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
        imageUrl: 'https://www.simplyrecipes.com/thmb/lAP-JFoUgr7IKaGcJRH45gROQ_8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Greek-Gyros-LEAD-01-82f62b48b2674c86b169faea6c2b5bb6.jpg',
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
      Product(
        id: '10',
        name: 'Chocolate Lava Cake',
        description: 'Warm chocolate cake with molten center and vanilla ice cream.',
        price: 4.49,
        imageUrl: 'https://www.simplyrecipes.com/thmb/x2oAfxW8HQyJfAcB_-dP5iEUX8c=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Chocolate-Lava-Cake-LEAD-06-8cb83f6be0d943acb3c40d38b6b69fd0.jpg',
        rating: 4.9,
        ratingCount: 312,
        isAvailable: true,
        ingredients: [
          {'name': 'Dark chocolate'},
          {'name': 'Butter'},
          {'name': 'Eggs'},
          {'name': 'Sugar'},
          {'name': 'Flour'},
          {'name': 'Vanilla ice cream'},
        ],
        allergens: [
          {'name': 'Dairy', 'severity': 'high'},
          {'name': 'Eggs', 'severity': 'high'},
          {'name': 'Gluten', 'severity': 'medium'},
        ],
      ),
      Product(
        id: '11',
        name: 'Fish and Chips',
        description: 'Beer-battered fish with crispy fries and tartar sauce.',
        price: 8.29,
        imageUrl: 'https://www.simplyrecipes.com/thmb/6pRDvjbrQWZ2LQcBOxfZUg6l8v8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Fish-And-Chips-LEAD-05-b3c707d40e4e4b5e9c8b8d7b21f8c8b4.jpg',
        rating: 4.0,
        ratingCount: 89,
        isAvailable: false,
        ingredients: [
          {'name': 'White fish'},
          {'name': 'Beer batter'},
          {'name': 'Potatoes'},
          {'name': 'Tartar sauce'},
          {'name': 'Malt vinegar'},
          {'name': 'Mushy peas'},
        ],
        allergens: [
          {'name': 'Fish', 'severity': 'high'},
          {'name': 'Gluten', 'severity': 'high'},
          {'name': 'Eggs', 'severity': 'medium'},
        ],
      ),
      Product(
        id: '12',
        name: 'Vegetarian Buddha Bowl',
        description: 'Quinoa bowl with roasted vegetables, chickpeas, and tahini.',
        price: 7.99,
        imageUrl: 'https://www.simplyrecipes.com/thmb/cNxTv2Xw1xmPULr4bL7YbR1j_yU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Simply-Recipes-Buddha-Bowl-LEAD-03-a9f5e2e5b9e54c6c9a5b5b5b5b5b5b5b.jpg',
        rating: 4.5,
        ratingCount: 167,
        isAvailable: true,
        ingredients: [
          {'name': 'Quinoa'},
          {'name': 'Chickpeas'},
          {'name': 'Sweet potatoes'},
          {'name': 'Broccoli'},
          {'name': 'Avocado'},
          {'name': 'Tahini'},
          {'name': 'Kale'},
          {'name': 'Pumpkin seeds'},
        ],
        allergens: [
          {'name': 'Sesame', 'severity': 'medium'},
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