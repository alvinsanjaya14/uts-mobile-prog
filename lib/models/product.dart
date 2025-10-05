import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final double rating;
  final int ratingCount;
  final bool isAvailable;
  final List<Map<String, dynamic>> ingredients;
  final List<Map<String, dynamic>> allergens;
  final int restaurantId;
  
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.rating = 0.0,
    this.ratingCount = 0,
    this.isAvailable = true,
    this.ingredients = const [],
    this.allergens = const [],
    this.restaurantId = 0,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? map['title'] ?? 'Unknown',
      description: map['description'] ?? '',
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      imageUrl: map['imageurl'] ?? map['imageUrl'] ?? map['image'],
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 0.0,
      ratingCount: map['ratingCount'] ?? map['rating_count'] ?? 0,
      isAvailable: map['isAvailable'] ?? map['is_available'] ?? true,
      ingredients: _parseIngredients(map['ingredients']),
      allergens: _parseAllergens(map['allergens']),
      restaurantId: map['restaurantId'] ?? map['restaurant_id'] ?? 0,
    );
  }

  static List<Map<String, dynamic>> _parseIngredients(dynamic ingredients) {
    if (ingredients == null) return [];
    if (ingredients is List) {
      return ingredients.map((item) {
        if (item is Map<String, dynamic>) return item;
        if (item is String) return {'name': item, 'quantity': null};
        return {'name': item.toString(), 'quantity': null};
      }).toList();
    }
    return [];
  }

  static List<Map<String, dynamic>> _parseAllergens(dynamic allergens) {
    if (allergens == null) return [];
    if (allergens is List) {
      return allergens.map((item) {
        if (item is Map<String, dynamic>) return item;
        if (item is String) return {'name': item, 'severity': 'mild'};
        return {'name': item.toString(), 'severity': 'mild'};
      }).toList();
    }
    return [];
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'imageUrl': imageUrl,
    'rating': rating,
    'ratingCount': ratingCount,
    'isAvailable': isAvailable,
    'ingredients': ingredients,
    'allergens': allergens,
    'restaurantId': restaurantId,
  };

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    double? rating,
    int? ratingCount,
    bool? isAvailable,
    List<Map<String, dynamic>>? ingredients,
    List<Map<String, dynamic>>? allergens,
    int? restaurantId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isAvailable: isAvailable ?? this.isAvailable,
      ingredients: ingredients ?? this.ingredients,
      allergens: allergens ?? this.allergens,
      restaurantId: restaurantId ?? this.restaurantId,
    );
  }

  @override
  List<Object?> get props => [
    id, 
    name, 
    description, 
    price, 
    imageUrl, 
    rating, 
    ratingCount, 
    isAvailable, 
    ingredients, 
    allergens, 
    restaurantId
  ];
}
