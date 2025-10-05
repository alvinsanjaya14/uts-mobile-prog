import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductController extends ChangeNotifier {
  final ProductService _service;
  ProductController(this._service);

  List<Product> _products = [];
  List<Product> _savedProducts = [];
  List<Product> _searchResults = [];
  bool _loading = false;
  bool _savedLoading = false;
  bool _searchLoading = false;
  String? _error;
  String? _savedError;
  String? _searchError;

  List<Product> get products => _products;
  List<Product> get savedProducts => _savedProducts;
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
      _savedProducts = await _service.fetchSavedProducts();
    } catch (e) {
      _savedError = e.toString();
    } finally {
      _savedLoading = false;
      notifyListeners();
    }
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
