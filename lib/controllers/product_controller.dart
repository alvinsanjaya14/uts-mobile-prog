import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductController extends ChangeNotifier {
  final ProductService _service;
  ProductController(this._service);

  List<Product> _products = [];
  // _products is the catalog / past orders placeholder (existing usage);
  // keep favorites separate from orders to avoid mixing them.
  List<Product> _savedProducts = []; // favorites
  List<Product> _newOrders = [];
  List<Product> _pastOrders = [];
  List<Product> _searchResults = [];
  bool _loading = false;
  bool _savedLoading = false;
  bool _searchLoading = false;
  String? _error;
  String? _savedError;
  String? _searchError;

  List<Product> get products => _products;
  List<Product> get savedProducts => _savedProducts; // favorites
  List<Product> get newOrders => _newOrders;
  List<Product> get pastOrders => _pastOrders;
  List<Product> get searchResults => _searchResults;
  bool get isLoading => _loading;
  bool get isSavedLoading => _savedLoading;
  bool get isSearchLoading => _searchLoading;
  String? get error => _error;
  String? get savedError => _savedError;
  String? get searchError => _searchError;

  Future<void> loadProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _service.fetchProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedProducts() async {
    _savedLoading = true;
    _savedError = null;
    notifyListeners();
    try {
      // Load favorites from persistent storage (SharedPreferences via service).
      // Do not merge with orders — favorites are separate.
      _savedProducts = await _service.fetchSavedProducts();
    } catch (e) {
      _savedError = e.toString();
    } finally {
      _savedLoading = false;
      notifyListeners();
    }
  }

  /// Load persisted orders (new & past) from SharedPreferences.
  Future<void> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final newJson = prefs.getStringList('orders_new') ?? [];
      final pastJson = prefs.getStringList('orders_past') ?? [];

      _newOrders = newJson
          .map((s) {
            try {
              final map = jsonDecode(s) as Map<String, dynamic>;
              return Product.fromMap(map);
            } catch (_) {
              return null;
            }
          })
          .whereType<Product>()
          .toList();

      _pastOrders = pastJson
          .map((s) {
            try {
              final map = jsonDecode(s) as Map<String, dynamic>;
              return Product.fromMap(map);
            } catch (_) {
              return null;
            }
          })
          .whereType<Product>()
          .toList();

      notifyListeners();
    } catch (e) {
      // ignore errors for now
    }
  }

  /// Persist orders to SharedPreferences.
  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final newJson = _newOrders.map((p) => jsonEncode(p.toMap())).toList();
    final pastJson = _pastOrders.map((p) => jsonEncode(p.toMap())).toList();
    await prefs.setStringList('orders_new', newJson);
    await prefs.setStringList('orders_past', pastJson);
  }

  Future<void> searchProducts(String query) async {
    _searchLoading = true;
    _searchError = null;
    notifyListeners();
    try {
      _searchResults = await _service.searchProducts(query);
    } catch (e) {
      _searchError = e.toString();
    } finally {
      _searchLoading = false;
      notifyListeners();
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    _searchError = null;
    notifyListeners();
  }

  /// Adds a product to the "new orders" list when checkout completes.
  void addOrder(Product product) {
    if (!_newOrders.any((p) => p.id == product.id)) {
      _newOrders.add(product);
      // persist
      _saveOrders();
      notifyListeners();
    }
  }

  /// Marks a new order as finished and moves it into past orders.
  void markOrderAsPast(Product product) {
    _newOrders.removeWhere((p) => p.id == product.id);
    if (!_pastOrders.any((p) => p.id == product.id)) {
      _pastOrders.add(product);
      // persist
      _saveOrders();
    }
    notifyListeners();
  }

  /// Toggles a product's saved status
  Future<void> toggleProductSaved(Product product) async {
    try {
      final isCurrentlySaved = await _service.isProductSaved(product.id);

      if (isCurrentlySaved) {
        await _service.removeProductFromFavorites(product.id);
        _savedProducts.removeWhere((p) => p.id == product.id);
      } else {
        await _service.saveProductToFavorites(product.id);
        if (!_savedProducts.any((p) => p.id == product.id)) {
          _savedProducts.add(product);
        }
      }

      notifyListeners();
    } catch (e) {
      _savedError = e.toString();
      notifyListeners();
    }
  }

  /// Checks if a product is currently saved
  Future<bool> isProductSaved(String productId) async {
    return await _service.isProductSaved(productId);
  }
}
